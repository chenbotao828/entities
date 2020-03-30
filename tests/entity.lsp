(deftest "entity")

(setq test_entity (entity))

(assert-eq ''str '(type (do test_entity 'id)))
(assert-eq '"DB_ENTITY" '(do test_entity 'DB_name))
(do test_entity 'save)
(assert-eq 'test_entity '(data_get "DB_entity" (do test_entity 'id)))
(do test_entity 'delete)
(assert-eq 'nil '(data_get "DB_entity" (do test_entity 'id)))
(assert-eq 'nil '(do test_entity 'ent))
(assert-eq 'nil '(do test_entity 'displaying))

(setq test_entity nil)

