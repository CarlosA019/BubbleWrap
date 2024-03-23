;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |BubbleWrap(done)|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require picturing-programs)
(require "posn-util.rkt")

;background
(define back (empty-scene 500 500))
;maybe we can make an array for the bubble colors and use rand there instead. that that there is
;no light yellow bubbles that blend in

;bubble struct
(define-struct bubble (pos radius color))

;making
(define (NBubble buubbl)
  (make-bubble (make-posn (random 500) (random 500))
               (+ 10 (random 50))
               (make-color (random 256) (random 256) (random 256))))

;makes the list of bubbles
(define (bubbleL num)
  (cond[(= num 1) (list (NBubble 0))] 
       [else (list* (NBubble 0) (bubbleL (- num 1)))])) 

;make model
(define bubblem (bubbleL 30))

;makes a bubble
(define (drawBubble bubbl)
  (circle (bubble-radius bubbl) "outline" (bubble-color bubbl)))

(define (placeBubble bubbl backgr)
  (place-image (drawBubble bubbl) (posn-x (bubble-pos bubbl)) (posn-y (bubble-pos bubbl)) backgr));place-image works better than overlay

;drawh
(define (drawh m)
  (cond[(empty? m) (overlay (text "yay" 20 "black") back)]
       [(= 1 (length m)) (placeBubble (first m) back)]
       [else (placeBubble (first m) (drawh (rest m)))]))

;did it touch?
(define (touch? bub x y)
  (<= (posn-distance (make-posn x y) (bubble-pos bub)) (bubble-radius bub)))

;popping
(define (pop? m x y e)
  (cond[(empty? m) (list )]
       [(touch? (first m) x y) (rest m)]
       [else (list* (first m) (pop? (rest m) x y e))]))

;mouseh
(define (mouseh m x y e)
  (cond[(mouse=? "button-down" e) (pop? m x y e)]
       [else m]))


;bangg
(big-bang bubblem
  (on-draw drawh)
  (on-mouse mouseh))
