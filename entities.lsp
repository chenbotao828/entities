(import "entities/entity")
(import "entities/shapes")

;; ;; ;; 最符合直觉的设计

;; ;; using al {ents} {parts} ... as storage
;; ;; '((handle . ent_obj))
;; (ent_redraw_off)
;; (ent_clear)
;; ;; remove and delete drawings of all entities in {ent}

;; (setq l (line (0 1) (2 3)))
;; ;; add line obj to {ent}
;; (ent_mod_set 'l '(p1 (0 0) color "blue" layer "0") )
;; ;; line changed attrs
;; (setq w (wall "F12" "D12"))
;; ;; add wall obj to {wall}
;; ;; add wall's lines obj to {ent} (using unique key as temp handle )
;; (ent_mod_set 'w '(lwidth 200 rwidth 0))
;; ;; wall's line changed attrs

;; (ent_redraw_all)
