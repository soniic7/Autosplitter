// Made By Arkhamfan69 And Sonic7
state("LEGO Voyagers") 
{
	string72 currentCheckpointGUID : "GameAssembly.dll", 0x0685DD78, 0xEA8, 0xA08, 0x14;
	bool creditsScrolling : "GameAssembly.dll", 0x0662E4F0, 0xB8, 0x700, 0x2B0;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Uhara.Settings.CreateFromXml("Components/LVoyagers_Settings.xml");
    vars.Helper.LoadSceneManager = true;
    vars.Uhara.EnableDebug();
}

init
{
// lookup table linking the chapter GUID strings to settings XML IDs
    vars.CheckpointMap = new Dictionary<string, string>() {
        { "1876a567-38b5-4743-8277-ed039ee08dd7", "0"  }, // Chapter 1
        { "29847524-c91d-4932-82a4-77be33a2da96", "1"  }, // Chapter 2
        { "dce8a624-754b-4332-8f17-c691ec4ad3ac", "2"  }, // Chapter 3
        { "7492724f-07a8-4c2e-8eae-1b5b5cfd44f3", "3"  }, // Chapter 4
        { "4825ac54-8368-4801-aa3d-9bd56c67c271", "4"  }, // Chapter 5
        { "34d8af13-6768-4958-a350-162e37f41e57", "5"  }, // Chapter 6
        { "28599da8-9f14-4c68-883e-31b039cc0a45", "6"  }, // Chapter 7
        { "e83bdb79-d3fa-4ea7-bea1-a5231b1109a0", "7"  }, // Chapter 8
        { "f204cc0b-2fcb-410d-92a1-4f208cda2656", "8"  }, // Chapter 9
        { "bac6bdca-191a-4061-a5ca-c933d0236637", "9"  }, // Chapter 10
        { "3d7a00fa-0eac-426b-a5d3-5b9982b0aeae", "10" }, // Chapter 11
        { "09552ebf-838a-4433-a465-6f8ed8c8f4cc", "11" }, // Chapter 12
        { "8645575a-9bd8-4431-a71a-17f3066101e2", "12" }, // Chapter 13
        { "440afb4f-c836-4f17-8cc4-58ece3e08b1e", "13" }, // Chapter 14
        { "996ad834-4d50-426c-9d4f-86c79a6c9a26", "14" }, // Chapter 15
        { "9ca0ce58-447f-4aa9-91cc-6b85666cb72b", "15" }, // Chapter 16
        { "5d72a980-8c86-436d-9a7e-afd037b126e7", "16" }, // Chapter 17
        { "75e1f3b2-b8b1-4788-9319-fa66eead5b68", "17" }, // Chapter 18
        { "a6be6a5a-aee0-4f86-9e13-d804ae614d67", "18" }, // Chapter 19
        { "fe75e92e-fc37-4f83-b9fd-8c5ccd29a211", "19" }, // Chapter 20
        { "a8b86a2e-0703-4f3b-8816-a8cc90a24fcc", "20" }, // Chapter 21
        { "976871d2-e7cb-4e8d-93c0-ca31efea50fd", "21" }, // Chapter 22
        { "b9c278c1-4942-473e-9356-4b46f3871a1f", "22" }, // Chapter 23
        { "ca4a513f-1774-4e6a-af86-52ffdbbdea5f", "23" }, // Chapter 24
        { "b4dd88ba-ca0d-4b3f-acd8-e784792982cd", "24" }, // Chapter 25
        { "3e913f14-3016-454c-849a-2b86870ce0db", "25" }, // Chapter 26
        { "f3d442d9-daf3-4d2c-9a6b-8a14f6ee234c", "26" }, // Chapter 27
        { "c184bbd2-a8cf-493b-8f94-01b955ca120a", "27" }, // Chapter 28
        { "d2a48874-8691-4d70-b58f-5610d865f838", "28" }, // Chapter 29
        { "82ac1a35-6ed2-4ff7-b9af-b10d3d3e9cad", "29" }, // Chapter 30
        { "f8e41d5c-5a3d-4f24-9384-2246a4bf585c", "30" }, // Chapter 31
        { "68babd07-e05e-44ac-8dbc-155f45e69b30", "31" }, // Chapter 32
        { "5c71aa0b-c6c0-49c5-a1a2-f3915bcfac34", "32" }, // Chapter 33
        { "1d0536eb-9fb4-43f9-8614-4494571d1413", "33" }, // Chapter 34
        { "ce1c90fd-fc48-49a6-921f-1b3a2e24885b", "34" }, // Chapter 35
        { "51f62c75-18b8-46fc-bd04-cc7f70136554", "35" }, // Chapter 36
        { "31fa56da-ed1f-49c5-9049-4450d8167803", "36" }  // Chapter 37
    };
}

update
{
    vars.Uhara.Update();
    vars.Helper.Update();
    vars.Helper.MapPointers();
	
    current.Scene = vars.Helper.Scenes.Active.Name ?? current.Scene;
    if (old.Scene != current.Scene) vars.Log("Scene Changed: " + current.Scene);
}

isLoading
{
    return current.Scene == "Foundation";
}

start
{
    if (settings["IL"])
    {
        if (current.Scene != "Foundation" && old.Scene == "Foundation") 
        {
            return true;
        }
    }
    
	// If we were on a loading screen and went into root (section 1)
    if (settings["Start"] && current.Scene == "nature_root" && old.Scene == "Foundation")
    {
        return true;
    }
}

split
{
	if (old.currentCheckpointGUID != current.currentCheckpointGUID) vars.Log("currentCheckpointGUID changed: " + current.currentCheckpointGUID);

	if (settings["Credits"] && (!old.creditsScrolling && current.creditsScrolling) && current.currentCheckpointGUID == "31fa56da-ed1f-49c5-9049-4450d8167803") 
	{
		return true;
	}

	if (current.currentCheckpointGUID != old.currentCheckpointGUID)
	{
	
		if (vars.CheckpointMap.ContainsKey(current.currentCheckpointGUID ?? "")) 
		{
			string settingId = vars.CheckpointMap[current.currentCheckpointGUID];
			if (settings.ContainsKey(settingId) && settings[settingId]) 
			{
				return true;
			}
		} 
	}
}