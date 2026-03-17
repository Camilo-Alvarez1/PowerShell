
$DomainName = "got.lab"

# OUs (Great Houses)
$Houses = @(
    "HouseStark",
    "HouseLannister",
    "HouseTargaryen",
    "HouseBaratheon",
    "HouseGreyjoy",
    "HouseTyrell",
    "HouseMartell",
    "HouseArryn",
    "HouseTully",
    "NightWatch"
)

# Users (Characters)
$Users = @{
    HouseStark     = @("EddardStark","CatelynStark","RobbStark","SansaStark","AryaStark","BranStark","JonSnow")
    HouseLannister = @("TywinLannister","CerseiLannister","JaimeLannister","TyrionLannister")
    HouseTargaryen = @("DaenerysTargaryen","ViserysTargaryen","RhaegarTargaryen")
    HouseBaratheon = @("RobertBaratheon","StannisBaratheon","RenlyBaratheon")
    HouseGreyjoy   = @("BalonGreyjoy","YaraGreyjoy","TheonGreyjoy")
    HouseTyrell    = @("MaceTyrell","MargaeryTyrell","LorasTyrell")
    HouseMartell   = @("DoranMartell","OberynMartell","TrystaneMartell")
    HouseArryn     = @("JonArryn","LysaArryn","RobinArryn")
    HouseTully     = @("HosterTully","EdmureTully","BryndenTully")
    NightWatch     = @("JeorMormont","SamwellTarly","AlliserThorne","EddisonTollett")
}

# Sites and Subnets
$Sites = @{
    "Winterfell-Site"     = "192.168.10.0/24"
    "KingsLanding-Site"   = "192.168.20.0/24"
    "Dragonstone-Site"    = "192.168.30.0/24"
    "CasterlyRock-Site"   = "192.168.40.0/24"
    "Highgarden-Site"     = "192.168.50.0/24"
    "Sunspear-Site"       = "192.168.60.0/24"
    "Pyke-Site"           = "192.168.70.0/24"
    "CastleBlack-Site"    = "192.168.80.0/24"
}

# Security Groups (Alliances)
$Alliances = @(
    "AllianceOfTheNorth",        # Stark + Tully + Arryn
    "LannisterBaratheonPact",
    "TargaryenStarkAlliance",
    "DorneTyrellPact"
)


# Armies / Military Groups
$Armies = @(
    "StarkArmy",
    "LannisterArmy",
    "Unsullied",
    "DothrakiHorde",
    "NightWatchRangers"
)

# File Shares
$FileShares = @{
    "TheNorth"      = @("HouseStark","HouseTully","HouseArryn")
    "SmallCouncil"  = @("HouseLannister","HouseBaratheon","HouseTyrell")
    "Dragons"       = @("HouseTargaryen","HouseStark")
    "NightWatch"    = @("NightWatch")
}

# GPO Names
$GPOs = @(
    "HouseStark-GPO",
    "HouseLannister-GPO",
    "HouseTargaryen-GPO",
    "NightWatch-GPO"
)