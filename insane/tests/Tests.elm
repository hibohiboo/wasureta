module Tests exposing (..)

import Test exposing (..)
import Expect
import HtmlParser

all : Test
all =
  describe "HtmlParser"
    [ test "basic" (\_ -> Expect.equal () (HtmlParser.parse ""))
    ]