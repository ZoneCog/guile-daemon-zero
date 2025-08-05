;;; agent-zero/hypergraph.scm --- Hypergraph AtomSpace Integration

;; Copyright © 2024 GNU Agent-Zero Genesis Project

;; This file is part of Guile-Daemon-Zero (Agent-Zero Genesis).

;;; Commentary:

;; This module provides hypergraph-based cognitive state representation
;; using AtomSpace-like structures for Agent-Zero Genesis.

;;; Code:

(define-module (agent-zero hypergraph)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:export (make-atomspace
            atomspace-add-node!
            atomspace-add-link!
            atomspace-query
            hypergraph-encode
            persistence-save
            persistence-load))

;;; AtomSpace Data Structures

(define-record-type <atom>
  (make-atom type name truth-value attention-value)
  atom?
  (type atom-type)
  (name atom-name)
  (truth-value atom-truth-value set-atom-truth-value!)
  (attention-value atom-attention-value set-atom-attention-value!))

(define-record-type <link>
  (make-link type targets truth-value attention-value)
  link?
  (type link-type)
  (targets link-targets)
  (truth-value link-truth-value set-link-truth-value!)
  (attention-value link-attention-value set-link-attention-value!))

;;; AtomSpace Operations

(define (make-atomspace)
  "Create a new AtomSpace for hypergraph storage."
  `((atoms . ())
    (links . ())
    (indices . ())))

(define (atomspace-add-atom! atomspace atom)
  "Add an atom to the AtomSpace."
  (let ((atoms (assoc-ref atomspace 'atoms)))
    (assoc-set! atomspace 'atoms (cons atom atoms))
    (update-indices! atomspace atom)))

(define (atomspace-add-node! atomspace node-type node-name)
  "Add a node to the AtomSpace."
  (let ((atom (make-atom node-type node-name 
                        (make-truth-value 1.0 1.0)
                        (make-attention-value 0.5))))
    (atomspace-add-atom! atomspace atom)
    atom))

(define (atomspace-add-link! atomspace link-type targets)
  "Add a link connecting atoms in the AtomSpace."
  (let ((link (make-link link-type targets
                        (make-truth-value 1.0 1.0)
                        (make-attention-value 0.5))))
    (let ((links (assoc-ref atomspace 'links)))
      (assoc-set! atomspace 'links (cons link links)))
    link))

(define (make-truth-value strength confidence)
  "Create a truth value with strength and confidence."
  `((strength . ,strength)
    (confidence . ,confidence)))

(define (make-attention-value importance urgency)
  "Create an attention value with importance and urgency."
  `((importance . ,importance)
    (urgency . ,urgency)))

;;; Query and Retrieval

(define (atomspace-query atomspace pattern)
  "Query the AtomSpace for atoms matching a pattern."
  (let ((atoms (assoc-ref atomspace 'atoms))
        (links (assoc-ref atomspace 'links)))
    (case (car pattern)
      ((node)
       (filter (lambda (atom)
                 (and (atom? atom)
                      (eq? (atom-type atom) (cadr pattern))))
               atoms))
      ((link)
       (filter (lambda (link)
                 (and (link? link)
                      (eq? (link-type link) (cadr pattern))))
               links))
      ((name)
       (filter (lambda (atom)
                 (and (atom? atom)
                      (equal? (atom-name atom) (cadr pattern))))
               atoms))
      (else '()))))

(define (find-atom-by-name atomspace name)
  "Find an atom by its name."
  (find (lambda (atom)
          (and (atom? atom)
               (equal? (atom-name atom) name)))
        (assoc-ref atomspace 'atoms)))

;;; Hypergraph Encoding

(define (hypergraph-encode data atomspace)
  "Encode data structure into hypergraph representation."
  (cond
    ((symbol? data)
     (atomspace-add-node! atomspace 'ConceptNode (symbol->string data)))
    ((string? data)
     (atomspace-add-node! atomspace 'ConceptNode data))
    ((list? data)
     (encode-list-as-hypergraph data atomspace))
    ((pair? data)
     (encode-pair-as-hypergraph data atomspace))
    (else
     (atomspace-add-node! atomspace 'ConceptNode (object->string data)))))

(define (encode-list-as-hypergraph lst atomspace)
  "Encode a list as hypergraph nodes and links."
  (let ((list-node (atomspace-add-node! atomspace 'ListNode "list")))
    (for-each (lambda (element index)
                (let ((element-node (hypergraph-encode element atomspace)))
                  (atomspace-add-link! atomspace 'ListLink 
                                     (list list-node element-node))))
              lst
              (iota (length lst)))
    list-node))

(define (encode-pair-as-hypergraph pair atomspace)
  "Encode a pair as hypergraph relationship."
  (let ((key-node (hypergraph-encode (car pair) atomspace))
        (value-node (hypergraph-encode (cdr pair) atomspace)))
    (atomspace-add-link! atomspace 'AssociativeLink 
                       (list key-node value-node))))

;;; Pattern Matching

(define (pattern-match atomspace pattern)
  "Perform pattern matching on the hypergraph."
  (case (car pattern)
    ((inheritance)
     (find-inheritance-patterns atomspace (cdr pattern)))
    ((similarity)
     (find-similarity-patterns atomspace (cdr pattern)))
    ((evaluation)
     (find-evaluation-patterns atomspace (cdr pattern)))
    (else
     (atomspace-query atomspace pattern))))

(define (find-inheritance-patterns atomspace args)
  "Find inheritance relationships in the hypergraph."
  (filter (lambda (link)
            (and (link? link)
                 (eq? (link-type link) 'InheritanceLink)))
          (assoc-ref atomspace 'links)))

(define (find-similarity-patterns atomspace args)
  "Find similarity relationships in the hypergraph."
  (filter (lambda (link)
            (and (link? link)
                 (eq? (link-type link) 'SimilarityLink)))
          (assoc-ref atomspace 'links)))

(define (find-evaluation-patterns atomspace args)
  "Find evaluation relationships in the hypergraph."
  (filter (lambda (link)
            (and (link? link)
                 (eq? (link-type link) 'EvaluationLink)))
          (assoc-ref atomspace 'links)))

;;; Attention and Importance

(define (update-attention-values! atomspace)
  "Update attention values based on ECAN principles."
  (let ((atoms (assoc-ref atomspace 'atoms))
        (links (assoc-ref atomspace 'links)))
    ;; Update atom attention values
    (for-each (lambda (atom)
                (let ((current-attention (atom-attention-value atom)))
                  (set-atom-attention-value! 
                   atom 
                   (decay-attention-value current-attention))))
              atoms)
    ;; Update link attention values
    (for-each (lambda (link)
                (let ((current-attention (link-attention-value link)))
                  (set-link-attention-value! 
                   link 
                   (decay-attention-value current-attention))))
              links)))

(define (decay-attention-value attention-value)
  "Apply attention decay over time."
  (let ((importance (assoc-ref attention-value 'importance))
        (urgency (assoc-ref attention-value 'urgency)))
    (make-attention-value (* importance 0.95) (* urgency 0.9))))

;;; Persistence

(define (persistence-save atomspace filename)
  "Save AtomSpace to persistent storage."
  (call-with-output-file filename
    (lambda (port)
      (write atomspace port))))

(define (persistence-load filename)
  "Load AtomSpace from persistent storage."
  (call-with-input-file filename
    (lambda (port)
      (read port))))

;;; Utility Functions

(define (update-indices! atomspace atom)
  "Update indices for efficient querying."
  ;; In a real implementation, this would maintain hash tables
  ;; for fast lookup by type, name, etc.
  (let ((indices (assoc-ref atomspace 'indices)))
    (assoc-set! atomspace 'indices 
                (cons `((type . ,(atom-type atom))
                        (name . ,(atom-name atom))
                        (atom . ,atom))
                      indices))))

(define (object->string obj)
  "Convert any object to string representation."
  (call-with-output-string
    (lambda (port)
      (write obj port))))

;;; agent-zero/hypergraph.scm ends here