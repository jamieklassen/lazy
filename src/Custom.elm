module Custom exposing (Custom(..), update, view)

import DeeplyNestedRecord exposing (DeeplyNestedRecord)
import Html exposing (Html)
import Msg exposing (Msg)


type Custom
    = Custom DeeplyNestedRecord


update : Msg -> Custom -> Custom
update msg (Custom record) =
    Custom (DeeplyNestedRecord.update msg record)


view : Custom -> Html Msg
view (Custom deeplyNestedRecord) =
    let
        nothing =
            Debug.log "Custom.view" deeplyNestedRecord
    in
    Html.text deeplyNestedRecord.field
