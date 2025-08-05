;;; agent-zero/attention.scm --- Economic Cognitive Attention Networks (ECAN)

;; Copyright © 2024 GNU Agent-Zero Genesis Project

;; This file is part of Guile-Daemon-Zero (Agent-Zero Genesis).

;;; Commentary:

;; This module implements Economic Cognitive Attention Networks (ECAN)
;; for dynamic attention allocation in Agent-Zero Genesis.

;;; Code:

(define-module (agent-zero attention)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:export (make-attention-network
            allocate-attention!
            update-importance!
            update-urgency!
            attention-focus
            rent-collection
            stimulus-propagation))

;;; Attention Value Records

(define-record-type <attention-value>
  (make-attention-value-record sti lti vlti)
  attention-value?
  (sti av-sti set-av-sti!)      ; Short-term importance
  (lti av-lti set-av-lti!)      ; Long-term importance  
  (vlti av-vlti set-av-vlti!))  ; Very long-term importance

;;; ECAN Network Structure

(define-record-type <ecan-network>
  (make-ecan-network-record atoms attention-bank focus-boundary selection-threshold)
  ecan-network?
  (atoms ecan-atoms set-ecan-atoms!)
  (attention-bank ecan-attention-bank set-ecan-attention-bank!)
  (focus-boundary ecan-focus-boundary set-ecan-focus-boundary!)
  (selection-threshold ecan-selection-threshold set-ecan-selection-threshold!))

;;; Attention Network Creation

(define (make-attention-network)
  "Create a new ECAN attention network."
  (make-ecan-network-record
   '()                          ; atoms
   1000.0                       ; attention-bank (total STI available)
   100.0                        ; focus-boundary (STI threshold for focus)
   50.0))                       ; selection-threshold (minimum STI for selection)

(define (make-attention-value sti lti vlti)
  "Create an attention value with specified importance levels."
  (make-attention-value-record sti lti vlti))

;;; Attention Allocation

(define (allocate-attention! network atoms stimuli)
  "Allocate attention based on stimuli and current network state."
  (for-each (lambda (atom stimulus)
              (update-sti! atom stimulus network))
            atoms stimuli)
  (normalize-attention! network)
  (apply-rent-collection! network))

(define (update-sti! atom stimulus network)
  "Update short-term importance based on stimulus."
  (let* ((current-av (get-attention-value atom))
         (current-sti (av-sti current-av))
         (new-sti (+ current-sti (* stimulus 10.0))))
    (set-av-sti! current-av new-sti)))

(define (normalize-attention! network)
  "Normalize attention values to conserve total attention budget."
  (let* ((atoms (ecan-atoms network))
         (total-sti (fold + 0 (map (lambda (atom)
                                    (av-sti (get-attention-value atom)))
                                  atoms)))
         (budget (ecan-attention-bank network)))
    (when (> total-sti budget)
      (let ((scale-factor (/ budget total-sti)))
        (for-each (lambda (atom)
                    (let ((av (get-attention-value atom)))
                      (set-av-sti! av (* (av-sti av) scale-factor))))
                  atoms)))))

;;; Attention Focus and Selection

(define (attention-focus network)
  "Return atoms currently in the attention focus."
  (let ((threshold (ecan-focus-boundary network)))
    (filter (lambda (atom)
              (>= (av-sti (get-attention-value atom)) threshold))
            (ecan-atoms network))))

(define (attentional-selection network)
  "Select atoms based on selection threshold."
  (let ((threshold (ecan-selection-threshold network)))
    (filter (lambda (atom)
              (>= (av-sti (get-attention-value atom)) threshold))
            (ecan-atoms network))))

;;; Rent Collection (Attention Decay)

(define (apply-rent-collection! network)
  "Apply rent collection to decay attention values over time."
  (for-each (lambda (atom)
              (rent-collection-atom! atom network))
            (ecan-atoms network)))

(define (rent-collection-atom! atom network)
  "Apply rent collection to a single atom."
  (let* ((av (get-attention-value atom))
         (sti (av-sti av))
         (lti (av-lti av))
         (vlti (av-vlti av)))
    ;; STI rent: higher rent for higher STI values
    (let ((sti-rent (* sti 0.01)))
      (set-av-sti! av (max 0 (- sti sti-rent))))
    ;; LTI rent: convert some STI to LTI
    (when (> sti 0)
      (let ((sti-to-lti (* sti 0.001)))
        (set-av-sti! av (- sti sti-to-lti))
        (set-av-lti! av (+ lti sti-to-lti))))
    ;; VLTI rent: convert some LTI to VLTI
    (when (> lti 100)
      (let ((lti-to-vlti (* lti 0.0001)))
        (set-av-lti! av (- lti lti-to-vlti))
        (set-av-vlti! av (+ vlti lti-to-vlti))))))

;;; Importance Updates

(define (update-importance! atom delta-sti delta-lti)
  "Update importance values for an atom."
  (let ((av (get-attention-value atom)))
    (set-av-sti! av (max 0 (+ (av-sti av) delta-sti)))
    (set-av-lti! av (max 0 (+ (av-lti av) delta-lti)))))

(define (update-urgency! atom urgency-factor)
  "Update urgency by boosting STI temporarily."
  (let* ((av (get-attention-value atom))
         (boost (* (av-sti av) urgency-factor)))
    (set-av-sti! av (+ (av-sti av) boost))))

;;; Stimulus Propagation

(define (stimulus-propagation network source-atom intensity links)
  "Propagate stimulus from source atom through connected atoms."
  (let ((propagated-intensity (* intensity 0.5)))
    (for-each (lambda (link)
                (let ((target-atoms (get-link-targets link source-atom)))
                  (for-each (lambda (target)
                              (update-sti! target propagated-intensity network))
                            target-atoms)))
              links)))

(define (get-link-targets link source-atom)
  "Get target atoms from a link, excluding the source atom."
  ;; Simplified implementation - in real system would traverse link structure
  '())

;;; Attention Spreading

(define (spread-attention network spreading-factor)
  "Spread attention between connected atoms."
  (let ((focus-atoms (attention-focus network)))
    (for-each (lambda (atom)
                (spread-from-atom atom network spreading-factor))
              focus-atoms)))

(define (spread-from-atom atom network factor)
  "Spread attention from a single atom to its neighbors."
  (let* ((av (get-attention-value atom))
         (sti (av-sti av))
         (spread-amount (* sti factor 0.1)))
    ;; Find connected atoms and spread attention
    ;; Simplified implementation
    (set-av-sti! av (max 0 (- sti spread-amount)))))

;;; Economic Dynamics

(define (wage-payment! network atom wage)
  "Pay wage to an atom for cognitive work performed."
  (let ((av (get-attention-value atom)))
    (set-av-sti! av (+ (av-sti av) wage))))

(define (tax-collection! network tax-rate)
  "Collect tax from high-STI atoms to redistribute attention."
  (let* ((atoms (ecan-atoms network))
         (total-tax 0))
    (for-each (lambda (atom)
                (let* ((av (get-attention-value atom))
                       (sti (av-sti av))
                       (tax (* sti tax-rate)))
                  (when (> sti 100)
                    (set-av-sti! av (- sti tax))
                    (set! total-tax (+ total-tax tax)))))
              atoms)
    ;; Redistribute collected tax
    (redistribute-attention! network total-tax)))

(define (redistribute-attention! network amount)
  "Redistribute attention amount across low-STI atoms."
  (let* ((atoms (ecan-atoms network))
         (low-sti-atoms (filter (lambda (atom)
                                 (< (av-sti (get-attention-value atom)) 10))
                               atoms))
         (per-atom (if (null? low-sti-atoms) 
                       0 
                       (/ amount (length low-sti-atoms)))))
    (for-each (lambda (atom)
                (let ((av (get-attention-value atom)))
                  (set-av-sti! av (+ (av-sti av) per-atom))))
              low-sti-atoms)))

;;; Utility Functions

(define (get-attention-value atom)
  "Get attention value for an atom (placeholder implementation)."
  ;; In real implementation, this would extract from atom structure
  (make-attention-value-record 50.0 10.0 1.0))

(define (set-attention-value! atom av)
  "Set attention value for an atom (placeholder implementation)."
  ;; In real implementation, this would update atom structure
  #t)

(define (attention-network-statistics network)
  "Generate statistics about the attention network."
  (let* ((atoms (ecan-atoms network))
         (total-sti (fold + 0 (map (lambda (atom)
                                    (av-sti (get-attention-value atom)))
                                  atoms)))
         (focus-count (length (attention-focus network)))
         (selected-count (length (attentional-selection network))))
    `((total-atoms . ,(length atoms))
      (total-sti . ,total-sti)
      (focus-count . ,focus-count)
      (selected-count . ,selected-count)
      (average-sti . ,(if (null? atoms) 0 (/ total-sti (length atoms)))))))

;;; agent-zero/attention.scm ends here