module DeeplyNestedRecord exposing (DeeplyNestedRecord, update)

import Msg exposing (Msg(..))


type alias DeeplyNestedRecord =
    { field : String }


update : Msg -> DeeplyNestedRecord -> DeeplyNestedRecord
update msg deeplyNestedRecord =
    { deeplyNestedRecord
        | field =
            case msg of
                Canary _ ->
                    deeplyNestedRecord.field

                Custom newField ->
                    newField
    }
