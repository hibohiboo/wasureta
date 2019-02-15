module SampleData exposing (miserablesGraph)

import Dict exposing (Dict)
import Graph
import Time


miserablesGraph =
    Graph.fromNodeLabelsAndEdgePairs
        [ "Myriel"
        , "Napoleon"
        , "Mlle.Baptistine"
        , "Mme.Magloire"
        ]
        [ ( 1, 0 )
        , ( 2, 0 )
        , ( 2, 0 )
        , ( 3, 0 )
        , ( 3, 2 )
        , ( 4, 0 )
        ]
