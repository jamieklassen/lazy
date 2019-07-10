port module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Lazy
import RemoteData
import Task exposing (Task)


port inbox : (String -> msg) -> Sub msg


port done : () -> Cmd msg


type alias Model =
    Maybe { field : String }


type Msg
    = Message String


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always (inbox Message)
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Just { field = "init" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update (Message msg) model =
    let
        nothing =
            Debug.log "Message" msg
    in
    ( model |> Maybe.map (\r -> { r | field = msg })
    , done ()
    )


view : Model -> Html Msg
view =
    Maybe.map .field
        >> Maybe.withDefault ""
        >> Debug.log "view"
        >> Html.text
