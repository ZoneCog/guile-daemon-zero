;; agent-zero-config.scm --- Agent-Zero Genesis Configuration

;; Copyright © 2024 GNU Agent-Zero Genesis Project

;; This configuration file defines the cognitive architecture for
;; Agent-Zero Genesis, including kernel specifications, attention
;; allocation parameters, and meta-cognitive settings.

;;; Cognitive Kernel Specifications

((kernel-specs . (
  ;; Logical Reasoning Kernel
  ((shape . (64 64))
   (function . logical-reasoning)
   (attention-weight . 0.8)
   (description . "Primary logical reasoning and inference"))
   
  ;; Pattern Learning Kernel  
  ((shape . (128 32))
   (function . pattern-learning)
   (attention-weight . 0.6)
   (description . "Pattern recognition and learning"))
   
  ;; Attention Allocation Kernel
  ((shape . (32 16))
   (function . attention-allocation)
   (attention-weight . 0.7)
   (description . "ECAN attention allocation and focus"))
   
  ;; Memory Consolidation Kernel
  ((shape . (256 16))
   (function . memory-consolidation)
   (attention-weight . 0.5)
   (description . "Long-term memory consolidation"))
   
  ;; Meta-Cognitive Kernel
  ((shape . (48 24))
   (function . meta-cognition)
   (attention-weight . 0.9)
   (description . "Self-reflection and meta-cognitive monitoring"))))

;;; Cognitive Goals and Objectives

 (goals . (reasoning 
          learning 
          attention 
          memory 
          meta-cognition
          pattern-matching
          self-optimization))

;;; Meta-Cognitive Configuration

 (meta-cognitive-level . 3)
 (recursive-depth-limit . 5)
 (self-modification-enabled . #t)

;;; Hypergraph AtomSpace Settings

 (hypergraph-persistence . #t)
 (atomspace-backup-interval . 300)  ; seconds
 (max-atoms . 1000000)
 (max-links . 2000000)

;;; Economic Cognitive Attention Network (ECAN) Parameters

 (attention-budget . 1000.0)       ; Total STI available
 (focus-boundary . 100.0)          ; STI threshold for attentional focus
 (selection-threshold . 50.0)      ; Minimum STI for selection
 (rent-rate . 0.01)                ; Attention decay rate
 (wage-rate . 10.0)                ; Reward for cognitive work
 (tax-rate . 0.05)                 ; Tax on high-STI atoms

;;; Tensor Field Configuration

 (tensor-precision . float32)
 (prime-encoding-enabled . #t)
 (tensor-compression . #t)
 (max-tensor-size . 1048576)       ; 1MB per tensor

;;; Communication and Networking

 (fifo-file . "~/.config/agent-zero/agent-zero.fifo")
 (socket-file . "~/.config/agent-zero/agent-zero.socket")
 (distributed-mode . #f)
 (network-port . 8080)

;;; Logging and Monitoring

 (log-level . info)                ; debug, info, warn, error
 (cognitive-telemetry . #t)
 (performance-monitoring . #t)
 (attention-logging . #t)

;;; Learning and Adaptation Parameters

 (learning-rate . 0.001)
 (adaptation-threshold . 0.1)
 (pattern-match-threshold . 0.8)
 (confidence-threshold . 0.7)

;;; Resource Constraints

 (max-memory-usage . 2147483648)   ; 2GB
 (max-cpu-cores . 4)
 (processing-timeout . 30)         ; seconds

;;; Experimental Features

 (quantum-cognition . #f)
 (distributed-consciousness . #f)
 (temporal-reasoning . #t)
 (causal-modeling . #t))

;; End of configuration