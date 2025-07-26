(define-non-fungible-token course-badge uint)

(define-map course-counters (string-ascii 32) uint)
(define-constant contract-owner tx-sender)

(define-public (mint-badge (course-name (string-ascii 32)) (student principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u401))
    (let (
          (current-id (default-to u0 (map-get? course-counters course-name)))
          (next-id (+ current-id u1))
         )
      (try! (nft-mint? course-badge next-id student))
      (map-set course-counters course-name next-id)
      (ok {course: course-name, badge-id: next-id})
    )
  )
)

(define-read-only (get-next-badge-id (course-name (string-ascii 32)))
  (ok (+ u1 (default-to u0 (map-get? course-counters course-name)))))


