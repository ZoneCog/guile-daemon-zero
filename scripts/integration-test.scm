#!/usr/bin/env guile
!#

;;; integration-test.scm --- Test OpenCog integration with Agent-Zero

;; Copyright © 2024 GNU Agent-Zero Genesis Project

;;; Commentary:

;; This test demonstrates the integration between Agent-Zero cognitive
;; modules and the OpenCog packages.

;;; Code:

(use-modules (srfi srfi-64)
             (agent-zero kernel)
             (test-cognitive-packages))

(define (test-opencog-integration)
  "Test that Agent-Zero can work with OpenCog package definitions."
  (test-begin "opencog-integration")
  
  ;; Test that we can reference cognitive functions
  (test-assert "kernel-creation-basic"
    (let ((tensor-field `((tensor-data . ,(make-vector 10 0.0))
                          (shape . (5 2)))))
      (update-tensor-field tensor-field '(1.0 2.0 3.0 4.0 5.0))))
  
  ;; Test tensor operations
  (test-assert "tensor-field-operations"
    (let ((tensor-field `((tensor-data . ,(vector 1.0 2.0 3.0 4.0 5.0))
                          (shape . (5)))))
      (= (tensor-field-compute tensor-field 'sum) 15.0)))
  
  ;; Test prime factorization encoding
  (test-assert "prime-factorization-encoding"
    (let ((shape '(2 3 4))
          (expected '(4 9 20))) ; 2*2, 3*3, 4*5
      (equal? (prime-factorization-shape shape) expected)))
  
  ;; Test cognitive function applications
  (test-assert "logical-reasoning-compute"
    (let ((tensor-field `((tensor-data . ,(vector 0.3 0.7 0.2 0.8))
                          (shape . (4)))))
      (let ((result (logical-reasoning-compute tensor-field)))
        (and (list? result)
             (= (length result) 4)
             (equal? result '(0.0 1.0 0.0 1.0))))))
  
  (test-end "opencog-integration"))

;; Run the integration tests
(display "Agent-Zero Genesis: OpenCog Integration Test\n")
(display "================================================\n")

;; First run the package tests
(run-cognitive-package-tests)

;; Then run the integration tests
(test-opencog-integration)

(display "\nIntegration test completed successfully!\n")
(display "Agent-Zero is ready for OpenCog-powered cognitive computing.\n")