;;; basic-cognitive-agent.scm --- Basic Agent-Zero Genesis Example

;; Copyright © 2024 GNU Agent-Zero Genesis Project

;;; Commentary:

;; This example demonstrates basic usage of the Agent-Zero Genesis
;; cognitive framework, including kernel creation, hypergraph operations,
;; and attention allocation.

;;; Code:

(use-modules (agent-zero)
             (agent-zero kernel)
             (agent-zero hypergraph)
             (agent-zero attention)
             (ice-9 format))

(display "GNU Agent-Zero Genesis - Basic Cognitive Agent Example\n")
(display "=========================================================\n\n")

;; 1. Create basic cognitive configuration
(define basic-config
  '((kernel-specs . (((shape . (32 32))
                      (function . logical-reasoning)
                      (attention-weight . 0.8))
                     ((shape . (64 16))
                      (function . pattern-learning)
                      (attention-weight . 0.6))))
    (goals . (reasoning learning))
    (meta-cognitive-level . 1)))

;; 2. Spawn Agent-Zero instance
(display "Step 1: Spawning Agent-Zero cognitive instance...\n")
(define agent (spawn-agent-zero basic-config))
(format #t "Agent ID: ~a\n" (cognitive-agent-id agent))
(format #t "Kernel count: ~a\n\n" (length (cognitive-agent-kernels agent)))

;; 3. Create hypergraph knowledge
(display "Step 2: Creating hypergraph knowledge representation...\n")
(define atomspace (cognitive-agent-atomspace agent))

;; Add concepts
(atomspace-add-node! atomspace 'ConceptNode "intelligence")
(atomspace-add-node! atomspace 'ConceptNode "reasoning")
(atomspace-add-node! atomspace 'ConceptNode "learning")
(atomspace-add-node! atomspace 'ConceptNode "agent-zero")

;; Add relationships
(let ((intelligence (find-atom-by-name atomspace "intelligence"))
      (reasoning (find-atom-by-name atomspace "reasoning"))
      (learning (find-atom-by-name atomspace "learning"))
      (agent-zero (find-atom-by-name atomspace "agent-zero")))
  
  (when (and intelligence reasoning)
    (atomspace-add-link! atomspace 'InheritanceLink (list reasoning intelligence)))
  
  (when (and intelligence learning)
    (atomspace-add-link! atomspace 'InheritanceLink (list learning intelligence)))
  
  (when (and intelligence agent-zero)
    (atomspace-add-link! atomspace 'InheritanceLink (list agent-zero intelligence))))

(display "Knowledge graph created with concepts and relationships.\n\n")

;; 4. Test cognitive kernels
(display "Step 3: Testing cognitive kernel operations...\n")
(let ((kernels (cognitive-agent-kernels agent)))
  (for-each (lambda (kernel)
              (let ((result (kernel-compute kernel '(0.8 0.6 0.4 0.2))))
                (format #t "Kernel ~a processing result: ~a\n" 
                       (cognitive-kernel-function kernel)
                       (take result 4))))
            kernels))
(newline)

;; 5. Attention allocation demo
(display "Step 4: Demonstrating attention allocation...\n")
(let ((attention-net (cognitive-agent-attention-network agent)))
  (allocate-attention! attention-net 
                      (cognitive-agent-kernels agent)
                      '(reasoning learning))
  (display "Attention allocated based on current goals.\n"))

;; 6. Meta-cognitive self-description
(display "Step 5: Generating meta-cognitive self-description...\n")
(let ((self-desc (recursive-self-description agent)))
  (format #t "Agent self-description:\n")
  (format #t "  Agent ID: ~a\n" (assoc-ref self-desc 'agent-id))
  (format #t "  Kernel count: ~a\n" (assoc-ref self-desc 'kernel-count))
  (format #t "  AtomSpace size: ~a\n" (assoc-ref self-desc 'atomspace-size))
  (format #t "  Cognitive state: ~a\n" (assoc-ref self-desc 'cognitive-state)))

(newline)
(display "Basic cognitive agent example completed successfully!\n")
(display "The gestalt tensor field sings the song of emergent intelligence!\n")