import Browser
import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)

main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL

type alias Model = 
  { workWeight : String
  }

init : Model
init = 
  { workWeight = "45"
  }


-- UPDATE

type Msg 
  = Input String

update : Msg -> Model -> Model
update msg model =
  case msg of

    Input weight ->
      { model | workWeight = weight }


-- VIEW

view : Model -> Html Msg
view model = 
    div []
    [ div [class "banner"] [h1 [] [text "CalcuWeightor2"] ] 
    , div [class "main" ] 
      [ table [] 
        [ tr [] 
          [ td [] [ text "Enter your workweight:"]
          , td [] [ input  [ value model.workWeight, onInput Input] [] ]
          ]
        ]
      , inputValidation model 
      ]
    ]
    
{- Validates data and displays a relevant error message 
  or sends the data off to be processed! -}
inputValidation : Model -> Html msg
inputValidation model =
  case String.toFloat( model.workWeight ) of
    Nothing -> 
      div [style "color" "red" ] [ text "Work weight must be a number"]
    
    Just weight ->
      if weight < 45 then 
        div [style "color" "red" ] [ text "Work weight must be at least 45"]

      else if not (twoPointFiveDivides model.workWeight) then
        div [style "color" "red" ] [ text "Work weight must be a multiple of 2.5"]

      else 
        calcuWeight weight

{- It was easier for me to check if a string that I know is a floating point number 
  is divided by 2.5 evenly rather than do a bunch of math, and this works! -}
twoPointFiveDivides : String -> Bool
twoPointFiveDivides s = 
  if String.contains "." s then 
    ( String.endsWith ".5" s ) && (endsWithOneOf ["2", "7"] ( String.dropRight 2 s ) ) 

  else 
    endsWithOneOf ["0", "5"] s  

{- A way of checking if a string ends with at least one of the input
  list of strings -}
endsWithOneOf :  List String -> String -> Bool
endsWithOneOf ls s = 
  List.foldr (\n m -> ( String.endsWith n s ) || m ) False ls

{- Runs the two required calcuweightions and formats the output -}
calcuWeight : Float -> Html msg
calcuWeight weight = 
  div [ class "container" ] 
    [ table [] 
      [ weightTableRow "Warm up 1:" ( warmUpWeight 1 weight)
      , weightTableRow "Warm up 2:" ( warmUpWeight 2 weight)
      , weightTableRow "Warm up 3:" ( warmUpWeight 3 weight)
      , weightTableRow "Work sets:" weight 
      ]
    ]


{- I was reusing this code block a lot so I abstracted it-}
weightTableRow : String -> Float -> Html msg
weightTableRow s w = 
  tr []        
    [ td [] [ text s ]
    , td [] [ text ( String.fromFloat w )] 
    , td [] [ text ( plates w regularPlates )]
    ]

-- CALCUWEIGHTIONS

{- The way I progress through my loaded warmups is to divide the diffrence between the empty bar and 
  my work set weight into four parts and add one of those parts to the bar after each loaded warmup 
  until the 4th addtion which is when its time to switch over to worksets -}
warmUpWeight : Float -> Float -> Float
warmUpWeight n w =
  roundToNearest 5 ( n * ( ( w - 45 ) / 4 ) + 45 )

{- I just think this is a neat function -}
roundToNearest : Float -> Float -> Float
roundToNearest y x = 
  toFloat( round( x / y ) ) * y

{- This removes the bar and half of the weight as that will be mirrored in practice -}
plates : Float -> List Float -> String
plates w ps =
  plateStack ( ( w - 45 ) / 2 ) ps

{- See if the weight remaning can have the current largest plate removed from it:
  If yes then append that weight to the front of the string with the next call of
  platestack
  If not then try again with the next plate down. 
  If no plates can be removed return the empty string. -}
plateStack : Float -> List Float -> String 
plateStack w ps =
  case ps of 
    [] -> ""
    p::psPrime -> 
      if w - p > 0 then 
        String.fromFloat(p) ++ ", " ++ (plateStack (w-p) ps)

      else if w - p == 0 then -- Seperated out this to avoid dangling ","
        String.fromFloat(p)

      else 
        plateStack w psPrime
              
regularPlates : List Float
regularPlates = [45,35,25,10,5,2.5,1.25]

oylmpicPlates : List Float
oylmpicPlates = 55::regularPlates
