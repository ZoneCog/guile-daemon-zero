# Agent-Zero Genesis Usage Guide

This guide provides practical examples and usage patterns for the GNU Agent-Zero Genesis cognitive computing platform.

## Quick Start

### 1. Setup and Installation

```bash
# Automated setup (recommended)
./scripts/setup-agent-zero.sh

# Manual setup with Guix
export AGENT_ZERO_MANIFEST=1
guix environment -m guix.scm
./autogen.sh && ./configure && make
```

### 2. Basic Usage

```bash
# Start the cognitive daemon
./pre-inst-env guile-daemon --config agent-zero-config.scm &

# Run basic example
./pre-inst-env guile examples/basic-cognitive-agent.scm

# Interactive usage
./pre-inst-env gdpipe '(use-modules (agent-zero))'
./pre-inst-env gdpipe '(spawn-agent-zero (load-agent-zero-config "agent-zero-config.scm"))'
```

## Core Modules Usage

### Agent-Zero Main Module

```scheme
(use-modules (agent-zero))

;; Create cognitive agent configuration
(define config '((kernel-specs . (((shape . (64 64))
                                   (function . logical-reasoning)
                                   (attention-weight . 0.8))))
                 (goals . (reasoning learning))
                 (meta-cognitive-level . 2)))

;; Spawn agent instance
(define agent (spawn-agent-zero config))

;; Generate self-description
(recursive-self-description agent)
```

### Cognitive Kernels

```scheme
(use-modules (agent-zero kernel))

;; Create cognitive kernel
(define kernel (spawn-cognitive-kernel 
                '(32 32)           ; tensor shape
                'logical-reasoning ; cognitive function
                0.8))              ; attention weight

;; Perform computation
(define result (kernel-compute kernel '(0.5 0.3 0.8 0.2)))

;; Update kernel state
(update-kernel-state kernel '(0.9 0.1 0.7 0.4))
```

### Hypergraph Operations

```scheme
(use-modules (agent-zero hypergraph))

;; Create AtomSpace
(define atomspace (make-atomspace))

;; Add nodes and links
(define human (atomspace-add-node! atomspace 'ConceptNode "Human"))
(define mortal (atomspace-add-node! atomspace 'ConceptNode "Mortal"))
(atomspace-add-link! atomspace 'InheritanceLink (list human mortal))

;; Query patterns
(atomspace-query atomspace '(node ConceptNode))
(pattern-match atomspace '(inheritance))

;; Encode complex data
(hypergraph-encode '(agent . ((status . active))) atomspace)
```

### Attention Networks (ECAN)

```scheme
(use-modules (agent-zero attention))

;; Create attention network
(define network (make-attention-network))

;; Create attention values
(define av1 (make-attention-value 80.0 20.0 5.0))  ; STI, LTI, VLTI
(define av2 (make-attention-value 45.0 15.0 3.0))

;; Allocate attention
(allocate-attention! network (list atom1 atom2) '(5.0 -2.0))

;; Apply economic dynamics
(wage-payment! network atom1 15.0)
(tax-collection! network 0.1)
```

## Configuration Examples

### Basic Configuration

```scheme
;; minimal-config.scm
((kernel-specs . (((shape . (32 32))
                   (function . logical-reasoning)
                   (attention-weight . 0.8))))
 (goals . (reasoning))
 (meta-cognitive-level . 1))
```

### Advanced Configuration

```scheme
;; advanced-config.scm
((kernel-specs . (((shape . (64 64))
                   (function . logical-reasoning)
                   (attention-weight . 0.8))
                  ((shape . (128 32))
                   (function . pattern-learning)
                   (attention-weight . 0.6))
                  ((shape . (32 16))
                   (function . attention-allocation)
                   (attention-weight . 0.7))))
 (goals . (reasoning learning attention meta-cognition))
 (meta-cognitive-level . 3)
 (attention-budget . 1000.0)
 (focus-boundary . 100.0))
```

## Example Workflows

### 1. Knowledge Base Reasoning

```scheme
;; Create knowledge base
(define kb (make-atomspace))

;; Add facts
(atomspace-add-node! kb 'ConceptNode "Socrates")
(atomspace-add-node! kb 'ConceptNode "Human")
(atomspace-add-node! kb 'ConceptNode "Mortal")

;; Add rules
(atomspace-add-link! kb 'InheritanceLink '("Socrates" "Human"))
(atomspace-add-link! kb 'InheritanceLink '("Human" "Mortal"))

;; Query and reason
(pattern-match kb '(inheritance))
```

### 2. Multi-Kernel Processing

```scheme
;; Create multiple specialized kernels
(define reasoning-kernel (spawn-cognitive-kernel '(64 64) 'logical-reasoning 0.8))
(define learning-kernel (spawn-cognitive-kernel '(128 32) 'pattern-learning 0.6))
(define attention-kernel (spawn-cognitive-kernel '(32 16) 'attention-allocation 0.7))

;; Coordinate processing
(define input-data '(0.8 0.6 0.4 0.2))
(define results (list (kernel-compute reasoning-kernel input-data)
                     (kernel-compute learning-kernel input-data)
                     (kernel-compute attention-kernel input-data)))
```

### 3. Attention-Driven Processing

```scheme
;; Create attention network with multiple atoms
(define net (make-attention-network))
(define atoms (list (make-attention-value 80.0 20.0 5.0)
                   (make-attention-value 45.0 15.0 3.0)
                   (make-attention-value 120.0 30.0 8.0)))

;; Apply stimuli based on current goals
(allocate-attention! net atoms '(10.0 -5.0 15.0))

;; Focus on high-attention atoms
(define focus-atoms (attention-focus net))

;; Process only focused atoms
(for-each process-atom focus-atoms)
```

## Development Patterns

### Custom Cognitive Functions

```scheme
;; Define custom cognitive function
(define (custom-reasoning-compute tensor-field)
  "Custom reasoning implementation"
  (let ((data (vector->list (assoc-ref tensor-field 'tensor-data))))
    ;; Custom processing logic
    (map (lambda (x) (* x 1.5)) data)))

;; Extend kernel module
(define-module (my-agent cognitive-extensions)
  #:use-module (agent-zero kernel)
  #:export (spawn-custom-kernel))

(define (spawn-custom-kernel shape attention-weight)
  (make-cognitive-kernel shape 
                        (create-tensor-field shape)
                        'custom-reasoning
                        attention-weight))
```

### Attention Strategies

```scheme
;; Goal-based attention allocation
(define (allocate-for-goals network goals)
  (let ((kernels (ecan-atoms network)))
    (for-each (lambda (kernel)
                (let ((relevance (calculate-goal-relevance kernel goals)))
                  (update-importance! kernel (* relevance 10.0) 0.0)))
              kernels)))

;; Dynamic attention rebalancing
(define (rebalance-attention network threshold)
  (let ((high-sti-atoms (filter (lambda (atom)
                                 (> (av-sti (get-attention-value atom)) threshold))
                               (ecan-atoms network))))
    (tax-collection! network 0.1)
    (spread-attention network 0.05)))
```

## Testing and Validation

### Module Testing

```bash
# Run test suite
./test-agent-zero.sh

# Test specific example
./pre-inst-env guile examples/basic-cognitive-agent.scm

# Validate configuration
./pre-inst-env guile -c "(load \"agent-zero-config.scm\")"
```

### Interactive Testing

```scheme
;; REPL testing session
(use-modules (agent-zero)
             (agent-zero kernel)
             (agent-zero hypergraph)
             (agent-zero attention))

;; Test kernel creation
(define test-kernel (spawn-cognitive-kernel '(16 16) 'logical-reasoning 0.5))
(kernel-compute test-kernel '(1.0 0.5 0.0))

;; Test hypergraph operations
(define test-as (make-atomspace))
(atomspace-add-node! test-as 'ConceptNode "test")

;; Test attention allocation
(define test-net (make-attention-network))
(allocate-attention! test-net '() '())
```

## Performance Considerations

### Memory Management

- Configure `max-memory-usage` in configuration
- Use tensor compression for large kernels
- Implement attention-based garbage collection

### Processing Optimization

- Balance kernel count vs. processing complexity
- Use attention focus to limit active processing
- Implement lazy evaluation for large hypergraphs

### Scalability

- Distribute kernels across multiple processes
- Use persistent storage for large AtomSpaces
- Implement attention-based resource allocation

## Troubleshooting

### Common Issues

1. **Module not found errors**
   ```bash
   # Ensure proper environment
   ./pre-inst-env guile
   ```

2. **Configuration errors**
   ```bash
   # Validate configuration syntax
   guile -c "(load \"agent-zero-config.scm\")"
   ```

3. **Memory issues**
   ```bash
   # Reduce tensor sizes or kernel count
   # Enable tensor compression
   ```

### Debug Mode

```scheme
;; Enable debugging
(define debug-config
  '((log-level . debug)
    (cognitive-telemetry . #t)
    (performance-monitoring . #t)))
```

## Integration Examples

### With External Systems

```scheme
;; REST API integration
(define (process-external-data data)
  (let ((agent (spawn-agent-zero default-config)))
    (kernel-compute (car (cognitive-agent-kernels agent)) data)))

;; File-based knowledge import
(define (import-knowledge-file filename)
  (let ((atomspace (make-atomspace)))
    (call-with-input-file filename
      (lambda (port)
        (hypergraph-encode (read port) atomspace)))))
```

### Custom Protocols

```scheme
;; Define cognitive protocol
(define-record-type <cognitive-message>
  (make-cognitive-message type data timestamp)
  cognitive-message?
  (type message-type)
  (data message-data)
  (timestamp message-timestamp))

;; Process cognitive messages
(define (process-cognitive-message msg agent)
  (case (message-type msg)
    ((stimulus)
     (allocate-attention! (cognitive-agent-attention-network agent)
                         (cognitive-agent-kernels agent)
                         (message-data msg)))
    ((query)
     (atomspace-query (cognitive-agent-atomspace agent) (message-data msg)))))
```

This completes the comprehensive usage guide for Agent-Zero Genesis. The system is now ready for cognitive computing applications!