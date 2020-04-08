; circle
; c: center_point -> point
; r: radius      -> num
(defcls 'circle 'entity '(c r))
(defmethod 
  'circle
  'dxf
  (lambda (self) 
    (list (cons 0 "CIRCLE") 
          (cons 10 (do self 'c))
          (cons 40 (do self 'r))
    )
  )
)

; point
; p -> point
(defcls 'point 'entity '(p))
(defmethod 
  'point
  'dxf
  (lambda (self) 
    (list (cons 0 "POINT") 
          (cons 10 (do self 'p))
    )
  )
)

; line
; p1: start_point -> point 
; p2 : end_point  -> point 
(defcls 
  'line
  'entity
  '(p1 p2)
)
(defmethod 
  'line
  'dxf
  (lambda (self) 
    (list (cons 0 "LINE") 
          (cons 10 (do self 'p1))
          (cons 11 (do self 'p2))
    )
  )
)


; arc
; c: center_point -> point
; r: radius       -> num
; a1: start_angle -> num (degree)
; a2: end_angle -> num (degree)
(defcls 'arc 'entity '(c r a1 a2))
(defmethod 
  'arc
  'dxf
  (lambda (self) 
    (list (cons 0 "ARC") 
          (cons 10 (do self 'c))
          (cons 40 (do self 'r))
          (cons 50 (math_radians (do self 'a1)))
          (cons 51 (math_radians (do self 'a2)))
    )
  )
)

; hatch
; point_and_bulge: point and its bulge(num) -> list
; pattern: hatch_pattern -> str
; rotate: hatch_rotate_ange -> num(degree)
; scale: hatch_scale -> num
(defcls 'hatch 'entity '(points_and_bulge pattern rotate scale))
(defmethod 
  'hatch
  'dxf
  (lambda (self / dxf1 dxf2 hatch_al pattern rotate scale) 
    (setq hatch_al (select 
                     (do self 'points_and_bulge)
                     (lambda (x) (if (list? x) (cons 10 x) (cons 42 x)))
                   )
          pattern  (do self 'pattern)
          rotate   (math_radians (do self 'rotate))
          scale    (do self 'scale)
          dxf1     (list 
                     '(0 . "HATCH")
                     '(100 . "AcDbEntity")
                     '(100 . "AcDbHatch")
                     '(10 0 0 0)
                     '(210 0 0 1)
                     (cons 2 pattern)
                     (if (= pattern "SOLID") '(70 . 1) '(70 . 0))
                     '(71 . 0)
                     '(91 . 1)
                     '(92 . 7)
                     '(72 . 1)
                     '(73 . 1)
                     (cons 93 
                           (length 
                             (where 
                               (do self 'points_and_bulge)
                               (lambda (x) (list? x))
                             )
                           )
                     )
                   )
          dxf2     (list '(97 . 0) 
                         '(75 . 0)
                         '(76 . 1)
                         (cons 52 rotate)
                         (cons 41 scale)
                         '(77 . 0)
                         '(78 . 1)
                         (cons 53 rotate)
                         '(43 . 0)
                         '(44 . 0)
                         '(45 . 0)
                         '(46 . 1)
                         '(79 . 0)
                         '(47 . 1)
                         '(98 . 1)
                         '(10 0 0 0)
                   )
    )
    (append dxf1 hatch_al dxf2)
  )
)
(defmethod 
  'hatch
  'pline
  (lambda (self) 
    (pline (do self 'points_and_bulge) t)
  )
)

; pline (lwpolyline)
; point_and_bulge: point and its bulge(num) -> list
; close: first and last point connect -> bool
(defcls 'pline 'entity '(points_and_bulge close))
(defmethod 
  'pline
  'dxf
  (lambda (self / pb) 
    (setq pb (do self 'points_and_bulge))
    (append 
      (list (cons 0 "LWPOLYLINE") 
            (cons 100 "AcDbEntity")
            (cons 100 "AcDbPolyline")
            (cons 90 (/ (length pb) 2))
            (cons 70 (if (do self 'close) 1 0))
      )
      (select pb (lambda (x) (if (list? x) (cons 10 x) (cons 42 x))))
    )
  )
)
(defmethod 
  'pline
  'hatch
  (lambda (self pattern rotate scale) 
    (hatch (do self 'points_and_bulge) pattern rotate scale)
  )
)
; text
; content: text content -> str
; p:  text_aligned_position -> point
; attrs_al: al for style(str) height(num) rotate(angle degree)width(num 0-1) slope(angle degree) attach_point(str) -> al 
  ; attach_point:
  ; tl top_left 左上, tm top_middle 中上, tr top_right 右上,
  ; ml middle_left 左中, mm middle_middle 正中, mr middle_right 右中,
  ; bl bottom_left 左下, bm bottom_middle 中下, br bottom_right 右下,
  ; l left 左, m middle 中, r right 右,
  ; a align 对齐, c c 中心, s spread 布满
(defcls 'text 'entity '(content p attrs_al))
  ;;tyle height rotate width slope attach_point
(defmethod 
  'text
  'dxf
  (lambda (self / al attach_point a72 a73 a10 a11) 
    (setq al           (do self 'attrs_al)
          attach_point (_or (list (dot al 'attach_point) nil))
    )
    (cond 
      ((nil? attach_point)
       (setq a72 0
             a73 0
       )
      )
      ((member attach_point (list "tl" "top_left" "左上"))
       (setq a72 0
             a73 3
       )
      )
      ((member attach_point (list "tm" "top_middle" "中上"))
       (setq a72 1
             a73 3
       )
      )
      ((member attach_point (list "tr" "top_right" "右上"))
       (setq a72 2
             a73 3
       )
      )
      ((member attach_point (list "ml" "middle_left" "左中"))
       (setq a72 0
             a73 2
       )
      )
      ((member attach_point (list "mm" "middle_middle" "正中"))
       (setq a72 1
             a73 2
       )
      )
      ((member attach_point (list "mr" "middle_right" "右中"))
       (setq a72 2
             a73 2
       )
      )
      ((member attach_point (list "bl" "bottom_left" "左下"))
       (setq a72 0
             a73 1
       )
      )
      ((member attach_point (list "bm" "bottom_middle" "中下"))
       (setq a72 1
             a73 1
       )
      )
      ((member attach_point (list "br" "bottom_right" "右下"))
       (setq a72 2
             a73 1
       )
      )
      ((member attach_point (list "l" "left" "左"))
       (setq a72 0
             a73 0
       )
      )
      ((member attach_point (list "m" "middle" "中"))
       (setq a72 1
             a73 0
       )
      )
      ((member attach_point (list "r" "right" "右"))
       (setq a72 2
             a73 0
       )
      )
      ((member attach_point (list "a" "align" "对齐"))
       (setq a72 3
             a73 0
       )
      )
      ((member attach_point (list "c" "c" "中心"))
       (setq a72 4
             a73 0
       )
      )
      ((member attach_point (list "s" "spread" "布满"))
       (setq a72 2
             a73 0
       )
      )
    )
    (if (and (= 0 a72) (= 0 a73)) 
      (setq a10 (dot self 'p)
            a11 (list 0 0)
      )
      (setq a10 (list 0 0)
            a11 (dot self 'p)
      )
    )
    (list 
      (cons 0 "TEXT")
      (cons 100 "AcDbEntity")
      (cons 100 "AcDbText")
      (cons 10 a10)
      (cons 40 (_or (list (dot al 'height) 350)))
      (cons 1 (dot self 'content))
      (cons 50 
            (_or 
              (list (if (dot al 'rotate) (math_radians (dot al 'rotate))) 0)
            )
      )
      (cons 41 (_or (list (dot al 'width) 1)))
      (cons 51 
            (_or 
              (list (if (dot al 'slope) (math_radians (dot al 'slope))) 0)
            )
      )
      (cons 7 (_or (list (dot al 'style) "Standard")))
      (cons 71 0)
      (cons 11 a11)
      (cons 100 "AcDbText")
      (cons 72 a72)
      (cons 73 a73)
    )
  )
)
; mtext
; content: text content -> str
; p:  text_aligned_position -> point
; attrs_al: al for style(str) height(num) rotate(angle degree) width(num 0-1) slope(angle degree) attach_point(str) -> al 
  ; attach_point:
  ; tl top_left 左上, tm top_middle 中上, tr top_right 右上,
  ; ml middle_left 左中, mm middle_middle 正中, mr middle_right 右中,
  ; bl bottom_left 左下, bm bottom_middle 中下, br bottom_right 右下,
(defcls 'mtext 'entity '(content p attrs_al))
(defmethod 
  'mtext
  'dxf
  (lambda (self / al attach_point a71 content_al content line_space_style) 
    (setq content          (do self 'content)
          al               (do self 'attrs_al)
          attach_point     (_or (list (dot al 'attach_point) nil))
          direction        (_or (list (dot al 'direction) nil))
          line_space_style (_or (list (dot al 'line_space_style) nil))
    )
    (while (> (len content) 250) 
      (setq content_al (append content_al 
                               (list (cons 3 (span content 0 250)))
                       )
            content    (span content 250 nil)
      )
    )
    (setq content_al (append content_al (list (cons 1 content))))
    (append 
      (list 
        (cons 0 "MTEXT")
        (cons 100 "AcDbEntity")
        (cons 100 "AcDbMText")
        (cons 10 (dot self 'p))
        (cons 40 (_or (list (dot al 'height) 350)))
        (cons 41 (_or (list (dot al 'line_width) 10000)))
        (cons 71 
              (cond 
                ((nil? attach_point) 1)
                ((member attach_point (list "tl" "top_left" "左上")) 1)
                ((member attach_point (list "tm" "top_middle" "中上")) 2)
                ((member attach_point (list "tr" "top_right" "右上")) 3)
                ((member attach_point (list "ml" "middle_left" "左中")) 4)
                ((member attach_point (list "mm" "middle_middle" "正中")) 5)
                ((member attach_point (list "mr" "middle_right" "右中")) 6)
                ((member attach_point (list "bl" "bottom_left" "左下")) 7)
                ((member attach_point (list "bm" "bottom_middle" "中下")) 8)
                ((member attach_point (list "br" "bottom_right" "右下")) 9)
              )
        )
        (cons 72 
              (cond 
                ((nil? direction) 1)
                ((member direction (list "lr" "left_to_right" "左右")) 1)
                ((member direction (list "tb" "top_to_bottom" "上下")) 3)
                ((member direction (list "bs" "by_style" "随样式")) 5)
              )
        )
      )
      content_al
      (list 
        (cons 7 (_or (list (dot al 'style) "Standard")))
        (cons 50 
              (_or 
                (list (if (dot al 'rotate) (math_radians (dot al 'rotate))) 
                      0
                )
              )
        )
        (cons 73 
              (cond 
                ((nil? line_space_style) 1)
                ((member line_space_style (list "at_least" "至少")) 1)
                ((member line_space_style (list "exact" "精确")) 2)
              )
        )
        (cons 44 (_or (list (dot al 'line_space_factor) 1)))
      )
    )
  )
)
; dim_line
; p1: start_point -> point
; p2: end_point -> point
; d: distance between line (p1 p2) and dim, left>0 -> num
(defcls 'dim_line 'entity '(p1 p2 d))
(defmethod 
  'dim_line
  'dxf
  (lambda (self / p1 p2 p3) 
    (setq p1 (do self 'p1)
          p2 (do self 'p2)
          p3 (polar p2 (+ (/ pi 2) (angle p1 p2)) (do self 'd))
    )
    (list 
      (cons 0 "DIMENSION")
      (cons 100 "AcDbEntity")
      (cons 100 "AcDbDimension")
      (cons 10 p3)
      (cons 70 1)
      (cons 3 (if {dim_style} {dim_style} "Standard"))
      (cons 100 "AcDbAlignedDimension")
      (cons 13 p1)
      (cons 14 p2)
    )
  )
)

; dim_angle
; p1: start_point -> point
; p2: angle_point -> point
; p3: end_point -> point
; r: radius of dim -> num
; dim_style: dim_style -> str
(defcls 'dim_angle 'entity '(p1 p2 p3 r))
  ; anticlockwise angle formed by p1 p2 p3
(defmethod 
  'dim_angle
  'dxf
  (lambda (self / p1 p2 p3 p4) 
    (setq p1 (do self 'p1)
          p2 (do self 'p2)
          p3 (do self 'p3)
          p4 (polar p2 (angle p2 p3) (do self 'r))
    )
    (list 
      (cons 0 "DIMENSION")
      (cons 100 "AcDbEntity")
      (cons 100 "AcDbDimension")
      (cons 10 p4)
      (cons 70 5)
      (cons 3 (if {dim_style} {dim_style} "Standard"))
      (cons 100 "AcDb3PointAngularDimension")
      (cons 13 p1)
      (cons 14 p3)
      (cons 15 p2)
    )
  )
)

; dim_circle
; c: center_point -> point
; r: radius -> num
; ang: angle(degree) of dim (clockwise from 12 o'clock )-> num
; dim_style: dim_style -> str
(defcls 'dim_circle 'entity '(c r ang))
(defmethod 
  'dim_circle
  'dxf
  (lambda (self / c r ang p1 p2) 
    (setq c   (do self 'c)
          r   (do self 'r)
          ang (math_radians (do self 'ang))
          p1  (polar c ang r)
          p2  (polar c ang (- 0 r))
    )
    (list 
      (cons 0 "DIMENSION")
      (cons 100 "AcDbEntity")
      (cons 100 "AcDbDimension")
      (cons 10 p2)
      (cons 70 35)
      (cons 3 (if {dim_style} {dim_style} "Standard"))
      (cons 100 "AcDbDiametricDimension")
      (cons 15 p1)
    )
  )
)

; dim_arc
; c: center_point -> point
; r: radius of dim -> num
; ang: angle(degree) of dim (clockwise from 12 o'clock )-> num
; dim_style: dim_style -> str
(defcls 'dim_arc 'entity '(c r ang))
(defmethod 
  'dim_arc
  'dxf
  (lambda (self / c r ang p) 
    (setq c   (do self 'c)
          r   (do self 'r)
          ang (math_radians (do self 'ang))
          p   (polar c ang r)
    )
    (list 
      (cons 0 "DIMENSION")
      (cons 100 "AcDbEntity")
      (cons 100 "AcDbDimension")
      (cons 10 c)
      (cons 70 36)
      (cons 3 (if {dim_style} {dim_style} "Standard"))
      (cons 100 "AcDbRadialDimension")
      (cons 15 p)
    )
  )
)
