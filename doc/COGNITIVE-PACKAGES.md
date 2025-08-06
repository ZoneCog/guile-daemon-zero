# Cognitive Packages for Agent-Zero Genesis

This document describes the cognitive computing packages available for Agent-Zero Genesis, including OpenCog and related frameworks.

## Overview

The Agent-Zero Genesis project provides Guix package definitions for cognitive computing frameworks that are not readily available in the main Guix repository. These packages enable the creation of advanced AI systems with hypergraph knowledge representation, attention allocation, and reasoning capabilities.

## Available Packages

### OpenCog AtomSpace (`opencog-atomspace`)

**Version:** 5.0.4  
**Description:** Hypergraph knowledge representation framework

The OpenCog AtomSpace is a hypergraph database and knowledge representation framework designed for Artificial General Intelligence (AGI) research. It provides:

- Graph database where vertices are called Atoms
- Edges (Links) can connect to an arbitrary number of vertices
- Complex knowledge representation capabilities
- Foundation for reasoning and learning algorithms

**Dependencies:**
- Boost C++ libraries
- GNU Guile 3.0
- Zlib compression library

### OpenCog Core (`opencog`)

**Version:** 5.0.4  
**Description:** Cognitive computing platform for AGI research

The main OpenCog framework that provides cognitive algorithms and reasoning systems:

- PLN (Probabilistic Logic Networks) for uncertain reasoning
- ECAN (Economic Cognitive Attention Networks) for attention allocation
- Pattern mining and cognitive algorithms
- Integration with hypergraph knowledge representation

**Dependencies:**
- OpenCog AtomSpace
- Boost C++ libraries
- GNU Guile 3.0

### GGML (`ggml`)

**Version:** 0.1.0  
**Description:** Tensor library for machine learning

GGML provides efficient tensor operations for machine learning:

- High-performance neural network operations
- Support for various architectures (x86, ARM)
- Optimized for commodity hardware
- Foundation for tensor-based cognitive computations

## Usage

### Building with Guix

To use these packages in a Guix environment:

```bash
# Create Agent-Zero environment with cognitive packages
export AGENT_ZERO_MANIFEST=1
guix environment -m guix.scm

# Or use in a containerized environment
guix shell -m guix.scm --container --pure
```

### Integration with Agent-Zero

The packages are automatically included when building the Agent-Zero environment:

```scheme
;; In your Guile code
(use-modules (agent-zero kernel)
             (agent-zero hypergraph)
             (agent-zero attention))

;; Create cognitive kernels with OpenCog integration
(define kernel (spawn-cognitive-kernel '(64 64) 'logical-reasoning 0.8))

;; Work with hypergraph knowledge
(define atomspace (make-atomspace))
(atomspace-add-node! atomspace "ConceptNode" "intelligence")
```

## Package Development

### Adding New Cognitive Packages

To add new cognitive computing packages:

1. Edit `modules/agent-zero/packages/cognitive.scm`
2. Add package definition using Guix package structure
3. Include appropriate dependencies and build configuration
4. Update `guix.scm` to include the new package in `agent-zero-os`

### Example Package Definition

```scheme
(define-public my-cognitive-package
  (package
    (name "my-cognitive-package")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/example/my-package.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "sha256-hash-here"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       '("-DCMAKE_BUILD_TYPE=Release"
         "-DENABLE_GUILE=ON")))
    (inputs
     `(("guile" ,guile-3.0)
       ("boost" ,boost)))
    (synopsis "Brief package description")
    (description "Detailed package description...")
    (home-page "https://example.com/")
    (license license:gpl3+)))
```

## Testing

To test the package definitions:

```bash
# Run package structure tests
cd guile-daemon-zero
GUILE_LOAD_PATH="$PWD/modules:$GUILE_LOAD_PATH" \
  guile -c "(use-modules (test-cognitive-packages)) (run-cognitive-package-tests)"
```

## Troubleshooting

### Common Issues

1. **Missing Dependencies**: Ensure all required system libraries are available
2. **Guile Integration**: Verify that packages are built with Guile support enabled
3. **Version Conflicts**: Check that package versions are compatible

### Build Flags

Important CMake flags for cognitive packages:

- `-DENABLE_GUILE=ON`: Enable Guile bindings
- `-DCMAKE_BUILD_TYPE=Release`: Optimized builds
- `-DENABLE_PYTHON=OFF`: Disable Python if not needed
- `-DWITH_MPI=OFF`: Disable MPI for single-node setups

## See Also

- [AGENT-ZERO-GENESIS.md](../AGENT-ZERO-GENESIS.md) - Complete development guide
- [USAGE.md](../USAGE.md) - General usage instructions
- [OpenCog Documentation](https://opencog.org/documentation/)
- [GGML Repository](https://github.com/ggerganov/ggml)
- [Guix Manual](https://guix.gnu.org/manual/)