;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |BubbleWrap (efficient)|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require picturing-programs)
(require "posn-util.rkt")

;distance formula
(define (dist p1 p2) (sqrt (+ (expt (- (posn-x p1) (posn-x p2)) 2) (expt (- (posn-y p1) (posn-y p2)) 2))))

;bubble structure
(define-struct bubble (pos radius color))

;list of bubbles-----------
(define (randb n)
  (cond [(= n 0) empty]
        [else (cons (make-bubble (make-posn (random 500) (random 500))
                            (random 50) (make-color (random 255) (random 255) (random 255) 255)) (randb (- n 1)))]))
;makes random bubbles

;draw handler on blist
(define (dh blist)
  (cond [(empty? blist) (square 500 "solid" "transparent")]
        [else (place-image (circle (bubble-radius (first blist)) "outline" (bubble-color (first blist)))
                           (posn-x (bubble-pos (first blist))) (posn-y (bubble-pos (first blist))) (dh (rest blist)))]))

;mouse handler
(define (mh blist x y event) (if (equal? event "button-down")
                                 (cond [(empty? blist) empty]
                                       [else (if (< (dist (bubble-pos (first blist)) (make-posn x y)) (bubble-radius (first blist)))
                                                 (rest blist) (cons (first blist) (mh (rest blist) x y "button-down")))]) blist))
  
;-----------bangg---------------
(big-bang (randb 10) (on-draw dh) (on-mouse mh))
