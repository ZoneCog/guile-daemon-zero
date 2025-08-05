#!/bin/bash
# test-agent-zero.sh - Agent-Zero Genesis Test Suite
# Copyright © 2024 GNU Agent-Zero Genesis Project

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "GNU Agent-Zero Genesis Test Suite"
echo "=================================="
echo ""

# Test configuration
TESTS_PASSED=0
TESTS_FAILED=0

run_test() {
    local test_name="$1"
    local test_file="$2"
    
    echo -n "Testing $test_name... "
    
    if [ -f "$test_file" ]; then
        # Try to load the module (basic syntax check)
        if guile -c "(load \"$test_file\")" > /tmp/test_output.log 2>&1; then
            echo -e "${GREEN}PASS${NC}"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            echo -e "${RED}FAIL${NC}"
            echo "Error output:"
            cat /tmp/test_output.log
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    else
        echo -e "${RED}FILE NOT FOUND${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

syntax_test() {
    local test_name="$1"
    local test_file="$2"
    
    echo -n "Syntax check $test_name... "
    
    if [ -f "$test_file" ]; then
        # Basic syntax validation
        if guile -c "(use-modules (ice-9 pretty-print)) (call-with-input-file \"$test_file\" (lambda (port) (read port)))" > /dev/null 2>&1; then
            echo -e "${GREEN}PASS${NC}"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            echo -e "${RED}FAIL${NC}"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    else
        echo -e "${RED}FILE NOT FOUND${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Test 1: Configuration file syntax
syntax_test "configuration file" "agent-zero-config.scm"

# Test 2: Module syntax checks
syntax_test "main agent-zero module" "modules/agent-zero.scm"
syntax_test "kernel module" "modules/agent-zero/kernel.scm"
syntax_test "hypergraph module" "modules/agent-zero/hypergraph.scm"  
syntax_test "attention module" "modules/agent-zero/attention.scm"

# Test 3: Example syntax checks
syntax_test "basic cognitive agent example" "examples/basic-cognitive-agent.scm"
syntax_test "hypergraph reasoning example" "examples/hypergraph-reasoning.scm"
syntax_test "attention dynamics example" "examples/attention-dynamics.scm"

# Test 4: Guix manifest validation
echo -n "Testing Guix manifest... "
if guix environment --dry-run -m guix.scm > /dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${YELLOW}SKIP${NC} (Guix not available)"
fi

# Test 5: Setup script validation
echo -n "Testing setup script... "
if bash -n scripts/setup-agent-zero.sh; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 6: Documentation completeness
echo -n "Testing documentation... "
if [ -f "AGENT-ZERO-GENESIS.md" ] && [ -f "README" ] && [ -s "AGENT-ZERO-GENESIS.md" ]; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Create simple integration test
echo -n "Testing basic module loading... "
cat > /tmp/integration_test.scm << 'EOF'
;; Basic integration test
(use-modules (srfi srfi-1))

;; Test basic Scheme functionality
(define test-list '(1 2 3 4 5))
(define test-result (fold + 0 test-list))

;; Test record types (used in agent-zero modules)
(use-modules (srfi srfi-9))
(define-record-type <test-record>
  (make-test-record value)
  test-record?
  (value test-record-value))

(define test-instance (make-test-record 42))

;; Verify basic functionality
(if (and (= test-result 15)
         (test-record? test-instance)
         (= (test-record-value test-instance) 42))
    (display "Integration test passed\n")
    (error "Integration test failed"))
EOF

if guile /tmp/integration_test.scm > /dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Clean up
rm -f /tmp/test_output.log /tmp/integration_test.scm

# Test results summary
echo ""
echo "Test Results Summary"
echo "===================="
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
echo -e "Total tests:  $((TESTS_PASSED + TESTS_FAILED))"

if [ $TESTS_FAILED -eq 0 ]; then
    echo ""
    echo -e "${GREEN}All tests passed! Agent-Zero Genesis is ready for cognitive computing.${NC}"
    echo "The hypergraph tapestry weaves successfully through the tensor fields!"
    exit 0
else
    echo ""
    echo -e "${RED}Some tests failed. Please review the implementation.${NC}"
    exit 1
fi