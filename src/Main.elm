port module Main exposing (main)

import Browser
import Custom exposing (Custom(..))
import DeeplyNestedRecord exposing (DeeplyNestedRecord)
import Html exposing (Html)
import Html.Lazy
import Msg exposing (Msg)
import RemoteData
import Task exposing (Task)


port customPort : (String -> msg) -> Sub msg


port canaryPort : (String -> msg) -> Sub msg


type alias Model =
    { canaryString : String
    , custom : Custom
    }


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions =
            always <|
                Sub.batch
                    [ canaryPort Msg.Canary
                    , customPort Msg.Custom
                    ]
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { canaryString = ""
      , custom = Custom { field = Debug.log "init" "" }
      }
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    Html.div
        []
        [ Html.text model.canaryString
        , Html.Lazy.lazy Custom.view model.custom
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        nothing =
            case msg of
                Msg.Custom newString ->
                    Debug.log "Custom" newString

                Msg.Canary newString ->
                    Debug.log "Canary" newString
    in
    ( { model
        | custom = Custom.update msg model.custom
        , canaryString =
            case msg of
                Msg.Custom _ ->
                    model.canaryString

                Msg.Canary newString ->
                    newString
      }
    , Cmd.none
    )
