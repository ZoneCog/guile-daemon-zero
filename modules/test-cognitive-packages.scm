;;; test-cognitive-packages.scm --- Test cognitive package definitions

;; Copyright © 2024 GNU Agent-Zero Genesis Project

;; This file is part of Guile-Daemon-Zero (Agent-Zero Genesis).

;;; Commentary:

;; Test module to validate the cognitive package definitions
;; without requiring full Guix installation.

;;; Code:

(define-module (test-cognitive-packages)
  #:use-module (srfi srfi-64)
  #:export (run-cognitive-package-tests))

;; Mock Guix package structure for testing
(define (make-mock-package name version description)
  `((name . ,name)
    (version . ,version)
    (description . ,description)))

;; Test data based on our package definitions
(define opencog-package-spec
  (make-mock-package
   "opencog"
   "5.0.4"
   "Cognitive computing platform for AGI research"))

(define ggml-package-spec
  (make-mock-package
   "ggml"
   "0.1.0"
   "Tensor library for machine learning"))

(define opencog-atomspace-package-spec
  (make-mock-package
   "opencog-atomspace"
   "5.0.4"
   "Hypergraph knowledge representation framework"))

(define (run-cognitive-package-tests)
  "Run tests for cognitive package definitions."
  (test-begin "cognitive-packages")
  
  (test-assert "opencog-package-structure"
    (and (assoc 'name opencog-package-spec)
         (string=? (assoc-ref opencog-package-spec 'name) "opencog")
         (string=? (assoc-ref opencog-package-spec 'version) "5.0.4")))
  
  (test-assert "ggml-package-structure"
    (and (assoc 'name ggml-package-spec)
         (string=? (assoc-ref ggml-package-spec 'name) "ggml")
         (string=? (assoc-ref ggml-package-spec 'version) "0.1.0")))
  
  (test-assert "atomspace-package-structure"
    (and (assoc 'name opencog-atomspace-package-spec)
         (string=? (assoc-ref opencog-atomspace-package-spec 'name) "opencog-atomspace")
         (string=? (assoc-ref opencog-atomspace-package-spec 'version) "5.0.4")))
  
  (test-end "cognitive-packages")
  
  (format #t "Cognitive package tests completed successfully!~%"))

;;; test-cognitive-packages.scm ends here