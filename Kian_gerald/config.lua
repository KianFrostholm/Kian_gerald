Config = {
    Dirtymoney = false, -- Skal man modtage sorte penge true/false
    DirtyItem = 'dirty_money', -- Item til sorte penge
    
    RewardType = 'money', -- money/item | Hvilken reward type 

    MoneyReward = math.random(10000, 50000), -- Højeste til mindste værdi chance ifht. penge reward

    Item = 'drugpack', -- Spawnkoden på drugpakken
    Runs = 4, -- Antal gange man skal hente pakker før man får sot reward
    Cooldown = 5, -- Tid i minutter

    Webhook = '', -- Webhook til logs
    Img = '', -- url til webhook billede
    Name = 'Kian_gerald', -- Navn til webhooket

    Interval = 5000, -- Update interval

    Locations = {
        {x = -1700.739, y = -1127.168,  z = 13.152},
        {x = -52.955,   y = -1314.527,  z = 29.221},
        {x = 196.941,   y = -1493.847,  z = 29.141},
        {x = 445.315,   y = -3115.725,  z = 6.070},
        {x = 153.953,   y = -3214.305,  z = 5.931},
        {x = 117.725,   y = -3311.712,  z = 6.018},
        {x = -830.200,  y = -401.397,   z = 31.423},
        {x = -2936.471, y = 32.352,     z = 11.605},
        {x = -2976.592, y = 700.418,    z = 28.491},
        {x = -2174.982, y = 4286.707,   z = 49.100},
        {x = 180.388,   y = 6395.338,   z = 31.364},
        {x = 1344.994,  y = 4390.959,   z = 44.343},
        {x = 2441.775,  y = 4072.015,   z = 38.064},
        {x = 802.644,   y = 2188.745,   z = 52.208},
        {x = -2193.432, y = -388.404,   z = 13.470},
        {x = 2545.218,  y = -363.547,   z = 56.614},
        {x = 1134.154,  y = -789.202,   z = 57.601},
        {x = 933.334,   y = -1458.377,  z = 31.181},
        {x = 483.385,   y = -1389.692,  z = 29.311},
        {x = -293.297,  y = -1905.680,  z = 29.946}
    },

    ItemReward = {
        {navn = 'hamp', antal = 10},
        {navn = 'kokain', antal = 8},
        {navn = 'lsd', antal = 1},
    },
}   



Lang = {
    ['talk_lamar']             	= '~b~[E]~w~ - Snak med Lamar',
    ['talk_gerald']             = '~b~[E]~w~ - Snak med Gerald',
    ['aflever_talk_gerald']     = '~b~[E]~w~ - Aflever pakken',
    ['start_mission']         	= '~b~[E]~w~ - Start mission',
    ['pickup_package']         	= '~b~[E]~w~ - Saml pakke',
    ['hent_pakke']         	    = 'Hent pakken og aflever den til Gerald',
    ['deliver_gerald']          = 'Køre tilbage og aflever pakken til Gerald',
    ['cooldown']         	    = '~r~Nedkøling',
    ['progressbar']             = 'Tager pakke',
  }