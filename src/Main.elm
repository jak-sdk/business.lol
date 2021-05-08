module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url



-- MAIN


main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }



-- MODEL


type alias Model =
  { key : Nav.Key
  , url : Url.Url
  }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
  ( Model key url, Cmd.none )



-- UPDATE


type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | url = url }
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none


-- VIEW


view : Model -> Browser.Document Msg
view model =
  { title = "URL Interceptor"
  , body =
      [ vHeader , vTopBanner
      , text "The current URL is: "
      , b [] [ text (Url.toString model.url) ]
      , ul []
          [ viewLink "/home"
          , viewLink "/profile"
          , viewLink "/reviews/the-century-of-the-self"
          , viewLink "/reviews/public-opinion"
          , viewLink "/reviews/shah-of-shahs"
          ]
      ]
  }

vHeader: Html Msg
vHeader =
  div [class "pt-6 pl-6 pr-6 flex flex-row"] 
   [ div [class "flex flex-row space-x-4"] 
      [ headerMenuItem "Home"
      , headerMenuItem "Away"
      ]
   , div [class "flex-grow"] []
   , div [class "flex flex-row-reverse gap-4"]
      [ headerMenuItem "Contact Someone Else"
      , headerMenuItem "Contact Us"
      ]
   ]

vTopBanner: Html Msg
vTopBanner =
  div [class "text-2xl"] [text "The fastest way to achieve your goals in the Business Arena!"]

headerMenuItem: String -> Html Msg
headerMenuItem name =
  div [class "w-45 h-16 rounded-md bg-yellow-500 hover:bg-yellow-300 text-white flex items-center justify-center text-2xl"] [ text name ]

viewLink : String -> Html Msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]
