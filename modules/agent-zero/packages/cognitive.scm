;;; cognitive.scm --- Cognitive Computing Packages for Agent-Zero Genesis

;; Copyright © 2024 GNU Agent-Zero Genesis Project

;; This file is part of Guile-Daemon-Zero (Agent-Zero Genesis).

;; Guile-Daemon-Zero is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; Guile-Daemon-Zero is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with Guile-Daemon-Zero.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This module provides package definitions for cognitive computing
;; frameworks used in Agent-Zero Genesis, including OpenCog, GGML,
;; and related AI/cognitive libraries.

;;; Code:

(define-module (agent-zero packages cognitive)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages machine-learning)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages tbb))

(define-public ggml
  (package
    (name "ggml")
    (version "0.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ggerganov/ggml.git")
             (commit "master")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0000000000000000000000000000000000000000000000000000"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       '("-DCMAKE_BUILD_TYPE=Release"
         "-DGGML_BUILD_TESTS=OFF"
         "-DGGML_BUILD_EXAMPLES=OFF")
       #:tests? #f)) ; Skip tests for now
    (synopsis "Tensor library for machine learning")
    (description
     "GGML is a tensor library for machine learning to enable large models
and high performance on commodity hardware.  It provides efficient
implementations for neural network operations and supports various
architectures including x86 and ARM.")
    (home-page "https://github.com/ggerganov/ggml")
    (license license:expat)))

(define-public opencog-atomspace
  (package
    (name "opencog-atomspace")
    (version "5.0.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/opencog/atomspace.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0000000000000000000000000000000000000000000000000000"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       '("-DCMAKE_BUILD_TYPE=Release"
         "-DENABLE_GUILE=ON"
         "-DGUILE_ROOT=/usr"
         "-DCMAKE_INSTALL_PREFIX=/gnu/store")
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'set-guile-environment
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (setenv "GUILE_AUTO_COMPILE" "0")
             (setenv "GUILE_LOAD_PATH"
                     (string-append (assoc-ref inputs "guile") "/share/guile/site/3.0:"
                                    (getenv "GUILE_LOAD_PATH")))
             #t)))))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("boost" ,boost)
       ("guile" ,guile-3.0)
       ("zlib" ,zlib)))
    (synopsis "Hypergraph knowledge representation framework")
    (description
     "The OpenCog AtomSpace is a hypergraph database and knowledge
representation framework designed for Artificial General Intelligence (AGI)
research.  It provides a graph database where vertices are called Atoms and
edges (Links) can connect to an arbitrary number of vertices.  The AtomSpace
supports complex knowledge representation, reasoning, and learning.")
    (home-page "https://opencog.org/")
    (license license:agpl3+)))

(define-public opencog
  (package
    (name "opencog")
    (version "5.0.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/opencog/opencog.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0000000000000000000000000000000000000000000000000000"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       '("-DCMAKE_BUILD_TYPE=Release"
         "-DENABLE_GUILE=ON"
         "-DENABLE_PYTHON=OFF"
         "-DWITH_MPI=OFF")
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'set-environment
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (setenv "OPENCOG_CMAKE_DIR"
                     (string-append (assoc-ref inputs "opencog-atomspace")
                                    "/lib/cmake/AtomSpace"))
             #t)))))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("boost" ,boost)
       ("guile" ,guile-3.0)
       ("opencog-atomspace" ,opencog-atomspace)
       ("zlib" ,zlib)))
    (propagated-inputs
     `(("opencog-atomspace" ,opencog-atomspace)))
    (synopsis "Cognitive computing platform for AGI research")
    (description
     "OpenCog is a cognitive computing platform designed for Artificial
General Intelligence (AGI) research.  It provides frameworks for reasoning,
learning, and cognitive processes including:
@itemize
@item PLN (Probabilistic Logic Networks) for uncertain reasoning
@item ECAN (Economic Cognitive Attention Networks) for attention allocation
@item Pattern mining and cognitive algorithms
@item Integration with hypergraph knowledge representation
@end itemize")
    (home-page "https://opencog.org/")
    (license license:agpl3+)))

;;; cognitive.scm ends here