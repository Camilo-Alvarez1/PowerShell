# Westeros
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

$Users = @{
    HouseStark     = @(
        "Eddard Stark",
        "Catelyn Stark",
        "Robb Stark",
        "Sansa Stark",
        "Arya Stark",
        "Bran Stark",
        "Jon Snow"
    )
    HouseLannister = @(
        "Tywin Lannister",
        "Cersei Lannister",
        "Jaime Lannister",
        "Tyrion Lannister"
    )
    HouseTargaryen = @(
        "Daenerys Targaryen",
        "Viserys Targaryen",
        "Rhaegar Targaryen"
    )
    HouseBaratheon = @(
        "Robert Baratheon",
        "Stannis Baratheon",
        "Renly Baratheon"
    )
    HouseGreyjoy   = @(
        "Balon Greyjoy",
        "Yara Greyjoy",
        "Theon Greyjoy"
    )
    HouseTyrell    = @(
        "Mace Tyrell",
        "Margaery Tyrell",
        "Loras Tyrell"
    )
    HouseMartell   = @(
        "Doran Martell",
        "Oberyn Martell",
        "Trystane Martell"
    )
    HouseArryn     = @(
        "Jon Arryn",
        "Lysa Arryn",
        "Robin Arryn"
    )
    HouseTully     = @(
        "Hoster Tully",
        "Edmure Tully",
        "Brynden Tully"
    )
    NightWatch     = @(
        "Jeor Mormont",
        "Samwell Tarly",
        "Alliser Thorne",
        "Eddison Tollett"
    )
    
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