;;; guix.scm – Agent-Zero Genesis Manifest

;; Copyright © 2016–2017, 2020 Alex Kost <alezost@gmail.com>
;; Copyright © 2024 GNU Agent-Zero Genesis Project

;; This file is part of Guile-Daemon-Zero (Agent-Zero Genesis).

;; Guile-Daemon-Zero is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; Guile-Daemon-Zero is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with Guile-Daemon-Zero.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This file contains the Agent-Zero Genesis manifest for building a
;; hypergraphically-encoded OS environment using GNU Guix, Guile, and
;; Guile-Stage0 for cognitive agent functions.
;;
;; To build the Agent-Zero environment:
;;
;;   guix shell -m guix.scm --container --pure
;;   guix environment -m guix.scm
;;
;; For development environment:
;;
;;   guix environment --pure --load=guix.scm
;;   ./autogen.sh
;;   ./configure
;;   make

;;; Code:

(use-modules
 (ice-9 popen)
 (ice-9 rdelim)
 (guix gexp)
 (guix packages)
 (guix profiles)
 (guix git-download)
 (guix build utils)
 (gnu packages)
 (gnu packages autotools)
 (gnu packages guile)
 (gnu packages guile-xyz)
 (gnu packages pkg-config)
 (gnu packages texinfo)
 (gnu packages machine-learning)
 (gnu packages maths)
 (gnu packages base)
 (gnu packages bash)
 (agent-zero packages cognitive))

(define %source-dir (dirname (current-filename)))

(define (git-output . args)
  "Execute 'git ARGS ...' command and return its output without trailing
newspace."
  (with-directory-excursion %source-dir
    (let* ((port   (apply open-pipe* OPEN_READ "git" args))
           (output (read-string port)))
      (close-pipe port)
      (string-trim-right output #\newline))))

(define (current-commit)
  (git-output "log" "-n" "1" "--pretty=format:%H"))

;; Agent-Zero OS Environment Packages
(define agent-zero-os
  (list
    ;; Bootstrap kernel foundation
    guile-3.0                    ; Core Scheme runtime
    guile-lib                    ; Extended Guile libraries
    
    ;; Cognitive computing frameworks
    opencog                      ; Cognitive computing platform
    opencog-atomspace            ; Hypergraph knowledge representation
    ggml                         ; Tensor operations library
    
    ;; Base system utilities
    coreutils                    ; Basic OS utilities
    bash                         ; Shell environment
    
    ;; Development tools
    autoconf                     ; Build system
    automake                     ; Build automation
    pkg-config                   ; Package configuration
    texinfo                      ; Documentation
    
    ;; Mathematics and computation
    ;; Note: Advanced AI packages like PLN, ECAN, MOSES will be added
    ;; as they become available in the cognitive packages module
    ))

;; Development environment for guile-daemon-zero
(define guile-daemon-devel
  (let ((commit (current-commit)))
    (package
      (inherit guile-daemon)
      (name "guile-daemon-zero")
      (version (string-append (package-version guile-daemon)
                              "-agent-zero-" (string-take commit 7)))
      (source (local-file %source-dir
                          #:recursive? #t
                          #:select? (git-predicate %source-dir)))
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'autogen
             (lambda _ (zero? (system* "sh" "autogen.sh")))))))
      (native-inputs
       (append (package-native-inputs guile-daemon)
               `(("autoconf" ,autoconf)
                 ("automake" ,automake)
                 ("texinfo" ,texinfo)))))))

;; For environment setup, export the full Agent-Zero manifest
(if (getenv "AGENT_ZERO_MANIFEST")
    (packages->manifest agent-zero-os)
    guile-daemon-devel)

;;; guix.scm ends here
