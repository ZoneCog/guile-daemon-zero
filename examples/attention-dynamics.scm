;;; attention-dynamics.scm --- ECAN Attention Dynamics Example

;; Copyright © 2024 GNU Agent-Zero Genesis Project

;;; Commentary:

;; This example demonstrates Economic Cognitive Attention Networks (ECAN)
;; in Agent-Zero Genesis, showing attention allocation, rent collection,
;; and economic dynamics of cognitive resources.

;;; Code:

(use-modules (agent-zero attention)
             (ice-9 format)
             (srfi srfi-1))

(display "GNU Agent-Zero Genesis - ECAN Attention Dynamics Example\n")
(display "=========================================================\n\n")

;; Create attention network
(define attention-net (make-attention-network))

(display "Setting up ECAN attention network...\n")
(format #t "Initial attention bank: ~a STI units\n" 
        (ecan-attention-bank attention-net))
(format #t "Focus boundary: ~a STI\n" 
        (ecan-focus-boundary attention-net))
(format #t "Selection threshold: ~a STI\n\n" 
        (ecan-selection-threshold attention-net))

;; Create mock atoms for demonstration
(define atom-a (make-attention-value 80.0 20.0 5.0))
(define atom-b (make-attention-value 45.0 15.0 3.0))
(define atom-c (make-attention-value 120.0 30.0 8.0))
(define atom-d (make-attention-value 25.0 10.0 2.0))
(define atom-e (make-attention-value 90.0 25.0 6.0))

(define test-atoms (list atom-a atom-b atom-c atom-d atom-e))
(set-ecan-atoms! attention-net test-atoms)

(display "Created test atoms with initial attention values:\n")
(for-each (lambda (atom index)
            (format #t "Atom ~a: STI=~a, LTI=~a, VLTI=~a\n"
                   (+ index 1)
                   (av-sti atom)
                   (av-lti atom)
                   (av-vlti atom)))
          test-atoms
          (iota (length test-atoms)))
(newline)

;; Demonstrate attention focus
(display "Step 1: Determining attentional focus...\n")
(let ((focus-atoms (attention-focus attention-net)))
  (format #t "Atoms in attentional focus: ~a out of ~a\n" 
          (length focus-atoms) (length test-atoms))
  (for-each (lambda (atom)
              (format #t "  Focus atom with STI: ~a\n" (av-sti atom)))
            focus-atoms))
(newline)

;; Apply stimuli and reallocate attention
(display "Step 2: Applying stimuli and reallocating attention...\n")
(define stimuli '(5.0 -2.0 15.0 -5.0 8.0))  ; Positive and negative stimuli

(allocate-attention! attention-net test-atoms stimuli)

(display "Attention values after stimulus application:\n")
(for-each (lambda (atom index stimulus)
            (format #t "Atom ~a: STI=~a (stimulus: ~a)\n"
                   (+ index 1)
                   (av-sti atom)
                   stimulus))
          test-atoms
          (iota (length test-atoms))
          stimuli)
(newline)

;; Demonstrate rent collection over time
(display "Step 3: Simulating attention dynamics over time...\n")
(display "Time step | Total STI | Focus count | Selection count\n")
(display "----------|-----------|-------------|----------------\n")

(let loop ((time-step 0))
  (when (< time-step 10)
    (let* ((total-sti (fold + 0 (map av-sti test-atoms)))
           (focus-count (length (attention-focus attention-net)))
           (selection-count (length (attentional-selection attention-net))))
      (format #t "~9a | ~9a | ~11a | ~15a\n" 
              time-step
              (inexact->exact (round total-sti))
              focus-count
              selection-count))
    
    ;; Apply rent collection
    (apply-rent-collection! attention-net)
    
    ;; Add small random stimuli
    (let ((random-stimuli (map (lambda (_) (- (random 4.0) 2.0)) test-atoms)))
      (allocate-attention! attention-net test-atoms random-stimuli))
    
    (loop (+ time-step 1))))

(newline)

;; Demonstrate economic dynamics
(display "Step 4: Economic attention dynamics...\n")

;; Wage payment for cognitive work
(display "Paying wages for cognitive work:\n")
(wage-payment! attention-net atom-c 20.0)  ; Reward active reasoning
(wage-payment! attention-net atom-e 15.0)  ; Reward pattern recognition
(format #t "Atom 3 STI after wage: ~a\n" (av-sti atom-c))
(format #t "Atom 5 STI after wage: ~a\n" (av-sti atom-e))

;; Tax collection and redistribution
(display "\nApplying attention tax and redistribution:\n")
(let ((pre-tax-total (fold + 0 (map av-sti test-atoms))))
  (tax-collection! attention-net 0.1)  ; 10% tax rate
  (let ((post-tax-total (fold + 0 (map av-sti test-atoms))))
    (format #t "Total STI before tax: ~a\n" (inexact->exact (round pre-tax-total)))
    (format #t "Total STI after redistribution: ~a\n" (inexact->exact (round post-tax-total)))))

;; Show final attention values
(display "\nFinal attention values:\n")
(for-each (lambda (atom index)
            (format #t "Atom ~a: STI=~a, LTI=~a, VLTI=~a\n"
                   (+ index 1)
                   (inexact->exact (round (av-sti atom)))
                   (inexact->exact (round (av-lti atom)))
                   (inexact->exact (round (av-vlti atom)))))
          test-atoms
          (iota (length test-atoms)))

;; Demonstrate attention spreading
(display "\nStep 5: Attention spreading simulation...\n")
(spread-attention attention-net 0.1)  ; 10% spreading factor
(display "Attention spread between connected atoms (simulated).\n")

;; Network statistics
(display "\nStep 6: Attention network statistics...\n")
(let ((stats (attention-network-statistics attention-net)))
  (format #t "Total atoms: ~a\n" (assoc-ref stats 'total-atoms))
  (format #t "Total STI: ~a\n" (inexact->exact (round (assoc-ref stats 'total-sti))))
  (format #t "Focus count: ~a\n" (assoc-ref stats 'focus-count))
  (format #t "Selected count: ~a\n" (assoc-ref stats 'selected-count))
  (format #t "Average STI: ~a\n" (inexact->exact (round (assoc-ref stats 'average-sti)))))

;; Importance update example
(display "\nStep 7: Manual importance updates...\n")
(update-importance! atom-a 10.0 5.0)   ; Boost importance
(update-urgency! atom-b 1.5)           ; Increase urgency
(format #t "Atom 1 STI after importance boost: ~a\n" (av-sti atom-a))
(format #t "Atom 2 STI after urgency boost: ~a\n" (av-sti atom-b))

(newline)
(display "ECAN attention dynamics example completed!\n")
(display "The economic cognitive attention flows like a living river of mind!\n")