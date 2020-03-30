(defcls 'entity 'document nil)

(defmethod 'entity 'ent
  (lambda (self)
    (if (do self 'handle)
        (handent (do self 'handle))
        nil
        )
    ))

(defun convert_to_dxf (attrs_al / ent_attrs_dxf)
  (setq ent_attrs_dxf
        '((LAYER . 8) (LINETYPE . 6) (COLOR_NUMBER . 62) (THICKNESS . 39)
          (LINEWEIGHT . 370) (LINETYPE_SCALE . 48) (VISIBILITY . 60)))
      (select attrs_al (lambda (i)
              (if (assoc (car i) ent_attrs_dxf)
                  (cons (dot ent_attrs_dxf (car i)) (cdr i))
                  )))
      )

(defmethod 'entity 'displaying
  (lambda (self / ent)
    (setq ent (do self 'ent))
    (if (and ent (entget ent)) t nil)
    )
  )
(defmethod 'entity 'draw_attrs
  (lambda (self attrs_al / ent id dxf handle DB_name )
    
    (setq id (do self 'id)
          DB_name (do self 'DB_name)
          self (data_get DB_name id) 
          ent (do self 'ent)
          dxf (append (convert_to_dxf attrs_al) (do self 'dxf))
          )
    (if (do self 'displaying)
        (entmod (cons (cons -1 ent) dxf))
        (progn
          (if ent (entdel ent) )
          (setq handle (cdr (assoc 5 (entget (entmakex dxf)))))
          (data_put DB_name id (setq self (al_upsert self 'handle handle)))
          )
        )
    self
    )
  )

(defun do_draw_attrs (self attrs_al)
  (do self (list 'draw_attrs attrs_al ))
   )

(defmethod 'entity 'draw
  (lambda (self)
    (do self '(draw_attrs nil))
    )
  )

(defmethod 'entity 'intersect_with 
  ;; mod : 0(extend none) 1(extend self) 2(extend other) 3(extend both)
  (lambda (self other mod / obj1 obj2 intpoints points i)
    (setq obj1 (vlax-ename->vla-object (do self 'ent))
          obj2 (vlax-ename->vla-object (do other 'ent))
          intpoints (vlax-variant-value (vla-intersectwith obj1 obj2 mod)) 
          i 0
          )
    (if (> (vlax-safearray-get-u-bound intpoints 1) 0)
        (repeat (/ (+ 1
                      (- (vlax-safearray-get-u-bound intpoints 1)
                         (vlax-safearray-get-l-bound intpoints 1)
                         )
                      )
                   3
                   )
                (setq points (append points (list (list
                                                    (vlax-safearray-get-element intpoints i)
                                                    (vlax-safearray-get-element intpoints (+ i 1))
                                                    (vlax-safearray-get-element intpoints (+ i 2))
                                                    )))
                      )
                (setq i (+ 3 i))))
    points)
  )