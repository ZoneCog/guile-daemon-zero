;;; hypergraph-reasoning.scm --- Hypergraph Reasoning Example

;; Copyright © 2024 GNU Agent-Zero Genesis Project

;;; Commentary:

;; This example demonstrates advanced hypergraph reasoning capabilities
;; in Agent-Zero Genesis, including pattern matching, inference, and
;; knowledge base queries.

;;; Code:

(use-modules (agent-zero hypergraph)
             (ice-9 format))

(display "GNU Agent-Zero Genesis - Hypergraph Reasoning Example\n")
(display "======================================================\n\n")

;; Create knowledge base
(define knowledge-base (make-atomspace))

(display "Building knowledge base...\n")

;; Add entities
(define socrates (atomspace-add-node! knowledge-base 'ConceptNode "Socrates"))
(define human (atomspace-add-node! knowledge-base 'ConceptNode "Human"))
(define mortal (atomspace-add-node! knowledge-base 'ConceptNode "Mortal"))
(define animal (atomspace-add-node! knowledge-base 'ConceptNode "Animal"))
(define mammal (atomspace-add-node! knowledge-base 'ConceptNode "Mammal"))

;; Add predicates
(define is-a (atomspace-add-node! knowledge-base 'PredicateNode "is-a"))
(define can-think (atomspace-add-node! knowledge-base 'PredicateNode "can-think"))

;; Build knowledge hierarchy
(atomspace-add-link! knowledge-base 'InheritanceLink (list socrates human))
(atomspace-add-link! knowledge-base 'InheritanceLink (list human mammal))
(atomspace-add-link! knowledge-base 'InheritanceLink (list mammal animal))
(atomspace-add-link! knowledge-base 'InheritanceLink (list animal mortal))

;; Add properties
(atomspace-add-link! knowledge-base 'EvaluationLink 
                    (list can-think (list socrates)))
(atomspace-add-link! knowledge-base 'EvaluationLink 
                    (list can-think (list human)))

(display "Knowledge base created with inheritance hierarchy.\n\n")

;; Query examples
(display "Performing knowledge base queries...\n")

;; Query 1: Find all concepts
(let ((concepts (atomspace-query knowledge-base '(node ConceptNode))))
  (format #t "Found ~a concepts: " (length concepts))
  (for-each (lambda (concept)
              (format #t "~a " (atom-name concept)))
            concepts)
  (newline))

;; Query 2: Find inheritance relationships  
(let ((inheritances (atomspace-query knowledge-base '(link InheritanceLink))))
  (format #t "Found ~a inheritance relationships\n" (length inheritances)))

;; Query 3: Pattern matching for inheritance chains
(display "\nTracing inheritance chain from Socrates:\n")
(define (trace-inheritance atomspace start-concept)
  (let loop ((current start-concept) (depth 0))
    (when (< depth 5)  ; Prevent infinite loops
      (format #t "~a~a\n" (make-string (* depth 2) #\space) 
             (if (atom? current) (atom-name current) current))
      ;; Find what this concept inherits from
      (let ((inheritance-links (filter (lambda (link)
                                        (and (link? link)
                                             (eq? (link-type link) 'InheritanceLink)
                                             (equal? (car (link-targets link)) current)))
                                      (assoc-ref atomspace 'links))))
        (for-each (lambda (link)
                    (let ((parent (cadr (link-targets link))))
                      (loop parent (+ depth 1))))
                  inheritance-links)))))

(trace-inheritance knowledge-base socrates)

;; Reasoning example: Transitive inheritance
(display "\nDemonstrating transitive reasoning:\n")
(define (inherits-from? atomspace concept1 concept2)
  "Check if concept1 inherits from concept2 (transitively)"
  (let loop ((current concept1) (visited '()) (depth 0))
    (cond
      ((> depth 10) #f)  ; Prevent infinite loops
      ((member current visited) #f)
      ((equal? current concept2) #t)
      (else
       (let ((inheritance-links (filter (lambda (link)
                                         (and (link? link)
                                              (eq? (link-type link) 'InheritanceLink)
                                              (equal? (car (link-targets link)) current)))
                                       (assoc-ref atomspace 'links))))
         (any (lambda (link)
                (let ((parent (cadr (link-targets link))))
                  (loop parent (cons current visited) (+ depth 1))))
              inheritance-links))))))

(format #t "Socrates inherits from Human: ~a\n" 
        (inherits-from? knowledge-base socrates human))
(format #t "Socrates inherits from Mortal: ~a\n" 
        (inherits-from? knowledge-base socrates mortal))
(format #t "Human inherits from Socrates: ~a\n" 
        (inherits-from? knowledge-base human socrates))

;; Advanced pattern matching
(display "\nAdvanced pattern matching examples:\n")

;; Find all evaluation patterns
(let ((evaluations (pattern-match knowledge-base '(evaluation))))
  (format #t "Found ~a evaluation patterns\n" (length evaluations)))

;; Encode complex knowledge structure
(display "\nEncoding complex data structure in hypergraph...\n")
(define complex-data 
  '((agent-zero . ((capabilities . (reasoning learning attention))
                   (architecture . ((kernels . 4)
                                   (memory . persistent)
                                   (attention . ecan)))
                   (status . active)))))

(hypergraph-encode complex-data knowledge-base)
(display "Complex data structure encoded as hypergraph nodes and links.\n")

;; Knowledge base statistics
(display "\nKnowledge base statistics:\n")
(let ((atoms (assoc-ref knowledge-base 'atoms))
      (links (assoc-ref knowledge-base 'links)))
  (format #t "Total atoms: ~a\n" (length atoms))
  (format #t "Total links: ~a\n" (length links))
  (format #t "Knowledge density: ~a links per atom\n" 
          (if (> (length atoms) 0)
              (exact->inexact (/ (length links) (length atoms)))
              0)))

(newline)
(display "Hypergraph reasoning example completed!\n")
(display "The AtomSpace pulses with the rhythm of knowledge!\n")