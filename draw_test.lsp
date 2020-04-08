;; Draw circle
(setq a (circle '(0 0) 1000))
(do a 'save)
(do a 'draw)
;; Draw point
(setq a (point '(100 100)))
(do a 'save)
(do a 'draw)
;; Draw line
(setq a (line '(0 0) '(2000 1000)))
(do a 'save)
(do a 'draw)
;; Draw arc
(setq a (arc '(0 0) 300 30 45))
(do a 'save)
(do a 'draw)
;; Draw hatch
(setq a (hatch '((0 0) 0 (1000 0) 1 ( 1000 1000) 0) "ANSI31" 30 1))
(do a 'save)
(do a 'draw)
;; Draw pline
(setq a (pline '((0 0) 0 (1000 0) 1 ( 1000 1000) 0) t))
(do a 'save)
(do a 'draw)

(setq a (text "你好" '(0 -300) nil))
(do a 'save)
(do a 'draw)

(setq a (mtext "森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒森大ss撒的撒撒的撒22" '(0 -500) nil))
(do a 'save)
(do a 'draw)

(setq {dim_style} "ISO-25")

(setq a (dim_line '(0 0) '(200 0) 100))
(do a 'save)
(do a 'draw)

(setq a (dim_angle '(200 200) '(0 0) '(-100 100) 50))
(do a 'save)
(do a 'draw)

(setq a (dim_circle '(-200 -200) 150 15 ))
(do a 'save)
(do a 'draw)

(setq a (dim_arc '(-200 -400) 150 15))
(do a 'save)
(do a 'draw)