port module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Lazy
import RemoteData
import Task exposing (Task)


port unobservablePort : (String -> msg) -> Sub msg


port msgPort : (String -> msg) -> Sub msg


type Msg
    = Observable String
    | Unobservable String


type Custom
    = Cons { field : String }


type alias Model =
    { string : String, custom : Custom }


main : Program () Model Msg
main =
    Browser.element
        { init =
            always
                ( { custom = Cons { field = "" }, string = "" }
                , Cmd.none
                )
        , view = view
        , update = update
        , subscriptions =
            always <|
                Sub.batch
                    [ msgPort Observable
                    , unobservablePort Unobservable
                    ]
        }


view : Model -> Html Msg
view model =
    Html.div
        []
        [ Html.text model.string
        , Html.Lazy.lazy viewCustom model.custom
        ]


viewCustom : Custom -> Html Msg
viewCustom (Cons record) =
    let
        nothing =
            Debug.log "calling viewCustom on" record
    in
    Html.text record.field


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        nothing =
            Debug.log "updating with" msg
    in
    ( { model
        | custom = updateCustom msg model.custom
        , string = updateString msg model.string
      }
    , Cmd.none
    )


updateCustom : Msg -> Custom -> Custom
updateCustom msg (Cons record) =
    -- here is the problem, since record update syntax always(?) breaks
    -- reference-equality
    Cons { record | field = updateOnObservable msg record.field }


updateOnObservable : Msg -> String -> String
updateOnObservable msg string =
    case msg of
        Observable field ->
            field

        Unobservable _ ->
            string


updateString : Msg -> String -> String
updateString msg string =
    case msg of
        Observable _ ->
            string

        Unobservable field ->
            field
