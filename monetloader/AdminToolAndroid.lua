require 'lib.moonloader'

local imgui = require 'mimgui' -- ������������� ���������� Moon ImGUI
local encoding = require 'encoding' -- ������ � �����������
local sampev = require 'lib.samp.events' -- ���������� ������� SA:MP � ������������/���������/�������� �.�. �������
local mim_addons = require 'mimgui_addons' -- ���������� ������� ��� ���������� mimgui
local fa = require 'fAwesome6_solid' -- ������ � ������� �� ������ FontAwesome 6
local inicfg = require 'inicfg' -- ������ � ��������
local toast_ok, toast = pcall(import, 'lib/mimtoasts.lua') -- ���������� �����������.
encoding.default = 'CP1251' -- ����� ��������� �� CP1251
u8 = encoding.UTF8 -- ���������� ��������� U8 ��� �������, �� � ����� ���������� (��� ����������)

-- ## ���� ��������� ���������� ## --
local tag = "{00BFFF} [AT] {FFFFFF}" -- ��������� ����������, ������� ������������ ��� AT
-- ## ���� ��������� ���������� ## --

-- ## ������� ������� � ���������� VARIABLE ## --
local new = imgui.new

local directIni = 'settings.ini'

local config = inicfg.load({
    settings = {
		first_start = true,
		device = "None",
        custom_recon = false,
		autologin = false,
		password_to_login = '',
    },
}, directIni)
inicfg.save(config, directIni)

function save()
    inicfg.save(config, directIni)
    toast.Show(u8"���������� �������� ������ �������.", toast.TYPE.OK, 5)
end

local elements = {
    imgui = {
        main_window = new.bool(false),
        recon_window = new.bool(false),
        menu_selectable = new.int(0),
        btn_size = imgui.ImVec2(70,0),
    },
    boolean = {
        recon = new.bool(config.settings.custom_recon),
		autologin = new.bool(config.settings.autologin),
    },
	buffers = {
		password = new.char[50](config.settings.password_to_login),
	},
}
-- ## ������� ������� � ���������� VARIABLE ## --

-- ## mimgui ## --
function Tooltip(text)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.Text(u8(text))
        imgui.EndTooltip()
    end 
end

imgui.OnInitialize(function()   
    imgui.GetIO().IniFilename = nil
    fa.Init()
end)

local sw, sh = getScreenResolution()
-- ## mimgui ## --

-- ## ���� ���������� ��������� � CustomReconMenu ## --
local ids_recon = {437, 2056, 2052, 144, 146, 141, 2050, 155, 153, 152, 156, 154, 160, 157, 179, 165, 159, 164, 162, 161, 180, 178, 163, 169, 181, 161, 166, 170, 168, 174, 182, 172, 171, 175, 173, 150, 184, 147, 148, 151, 149, 142, 143, 184, 177, 145, 158, 167, 183, 176}
local info_to_player = {}
local recon_info = { "��������: ", "�����: ", "�� ������: ", "��������: ", "����: ", "�������: ", "�������: ", "������� ��������: ", "����� � ���: ", "P.Loss: ", "������� VIP: ", "��������� �����: ", "�����-�����: ", "��������: "}
local right_recon = new.bool(true)
local accept_load_recon = false 
local recon_id = -1
local control_to_player = false
-- ## ���� ���������� ��������� � CustomReconMenu ## --


function main()

	if config.settings.first_start then  
		sampShowDialog(_, "{00BFFF} [Mobile AT] {FFFFFF}�������� ������������� ����������.", "�� ������� � ��������? \n\n���� �������� <��>, �� ��������� ���� ����� ������������� ��� �������. \n���� <���>, �� ��������� ����� ��� ��.", "��", "���")
	end

    if toast_ok then 
        toast.Show(u8"AdminTool ���������������.\n��� ������ � �����������, �������: /tool", toast.TYPE.INFO, 5)
    else 
        sampAddChatMessage('[AT] AdminTool ������� ���������������. ���������: /tool', -1)
        sampAddChatMessage("[AT] ����� � ��������� �����������", -1)
    end

    load_recon = lua_thread.create_suspended(loadRecon)

    -- ## ����������� ������ ��������� � ������� ������-��������� ���� ## --
    sampRegisterChatCommand("cp", cmd_cpfd)
    sampRegisterChatCommand("rpo", cmd_report_popr)
    sampRegisterChatCommand("rrz", cmd_rrz)
    sampRegisterChatCommand("roa", cmd_roa)
    sampRegisterChatCommand("ror", cmd_ror)
    sampRegisterChatCommand("rup", cmd_rup)
    sampRegisterChatCommand("rok", cmd_rok)
    sampRegisterChatCommand("rm", cmd_rm)
    sampRegisterChatCommand("rnm", cmd_report_neadekvat)
    -- ## ����������� ������ ��������� � ������� ������-��������� ���� ## --

    -- ## ����������� ������ ��������� � ������� offline-��������� ���� ## --
    sampRegisterChatCommand("am", cmd_am)
    sampRegisterChatCommand("aok", cmd_aok)
    sampRegisterChatCommand("afd", cmd_afd)
    sampRegisterChatCommand("apo", cmd_apo)
    sampRegisterChatCommand("aoa", cmd_aoa)
    sampRegisterChatCommand("aup", cmd_aup)
    sampRegisterChatCommand("anm", cmd_offline_neadekvat)
    sampRegisterChatCommand("aor", cmd_aor)
    sampRegisterChatCommand("aia", cmd_aia)
    sampRegisterChatCommand("akl", cmd_akl)
    sampRegisterChatCommand("arz", cmd_arz)
    sampRegisterChatCommand("azs", cmd_azs)
    -- ## ����������� ������ ��������� � ������� offline-��������� ���� ## --

    -- ## ����������� ������ ��������� � ������� offline-��������� ������ ## --
    sampRegisterChatCommand("ajcw", cmd_ajcw)
    sampRegisterChatCommand("ask", cmd_ask)
    sampRegisterChatCommand("adz", cmd_adz)
    sampRegisterChatCommand("afsh", cmd_afsh)
    sampRegisterChatCommand("atd", cmd_atd)
    sampRegisterChatCommand("abag", cmd_abag)
    sampRegisterChatCommand("apk", cmd_apk)
    sampRegisterChatCommand("azv", cmd_azv)
    sampRegisterChatCommand("askw", cmd_askw)
    sampRegisterChatCommand("angw", cmd_angw)
    sampRegisterChatCommand("adbgw", cmd_adbgw)
    sampRegisterChatCommand("adgw", cmd_adgw)
    sampRegisterChatCommand("ajch", cmd_ajch)
    sampRegisterChatCommand("apmx", cmd_apmx)
    sampRegisterChatCommand("asch", cmd_asch)
    -- ## ����������� ������ ��������� � ������� offline-��������� ������ ## --

    -- ## ����������� ������ ��������� � ������� ��������� ������ ## --
    sampRegisterChatCommand("sk", cmd_sk)
    sampRegisterChatCommand("dz", cmd_dz)
    sampRegisterChatCommand("jm", cmd_jm)
    sampRegisterChatCommand("td", cmd_td)
    sampRegisterChatCommand("skw", cmd_skw)
    sampRegisterChatCommand("ngw", cmd_ngw)
    sampRegisterChatCommand("dbgw", cmd_dbgw)
    sampRegisterChatCommand("fsh", cmd_fsh)
    sampRegisterChatCommand("bag", cmd_bag)
    sampRegisterChatCommand("pmx", cmd_pmx)
    sampRegisterChatCommand("pk", cmd_pk)
    sampRegisterChatCommand("zv", cmd_zv)
    sampRegisterChatCommand("jch", cmd_jch)
    sampRegisterChatCommand("dgw", cmd_dgw)
    sampRegisterChatCommand("sch", cmd_sch)
    sampRegisterChatCommand("jcw", cmd_jcw)
    sampRegisterChatCommand("tdbz", cmd_tdbz)
    -- ## ����������� ������ ��������� � ������� ��������� ������ ## --

    -- ## ����������� ������ ��������� � ������� ��������� ���� ## --
    sampRegisterChatCommand("pl", cmd_pl)
    sampRegisterChatCommand("ob", cmd_ob)
    sampRegisterChatCommand("hl", cmd_hl)
    sampRegisterChatCommand("nk", cmd_nk)
    sampRegisterChatCommand("menk", cmd_menk)
    sampRegisterChatCommand("gcnk", cmd_gcnk)
    sampRegisterChatCommand("bnm", cmd_bnm)
    -- ## ����������� ������ ��������� � ������� ��������� ���� ## --

    -- ## ����������� ������ ��������� � ������� offline-��������� ���� ## --
    sampRegisterChatCommand("aob", cmd_aob)
    sampRegisterChatCommand("ahl", cmd_ahl)
    sampRegisterChatCommand("ahli", cmd_ahli)
    sampRegisterChatCommand("apl", cmd_apl)
    sampRegisterChatCommand("ach", cmd_ach)
    sampRegisterChatCommand("achi", cmd_achi)
    sampRegisterChatCommand("ank", cmd_ank)
    sampRegisterChatCommand("amenk", cmd_amenk)
    sampRegisterChatCommand("agcnk", cmd_agcnk)
    sampRegisterChatCommand("agcnkip", cmd_agcnkip)
    sampRegisterChatCommand("rdsob", cmd_rdsob)
    sampRegisterChatCommand("rdsip", cmd_rdsip)
    sampRegisterChatCommand("abnm", cmd_abnm)
    -- ## ����������� ������ ��������� � ������� offline-��������� ���� ## --

    -- ## ����������� ������ ��������� � ������� ��������� ���� ## --
    sampRegisterChatCommand("dj", cmd_dj)
    sampRegisterChatCommand("gnk", cmd_gnk)
    sampRegisterChatCommand("cafk", cmd_cafk)
    -- ## ����������� ������ ��������� � ������� ��������� ���� ## --

    -- ## ����������� ��������������� ������ ## --
    sampRegisterChatCommand("u", cmd_u)
	sampRegisterChatCommand("uu", cmd_uu)
	sampRegisterChatCommand("uj", cmd_uj)
	sampRegisterChatCommand("as", cmd_as)
	sampRegisterChatCommand("stw", cmd_stw)
	sampRegisterChatCommand("ru", cmd_ru)
    -- ## ����������� ��������������� ������ ## --    

	sampRegisterChatCommand('checksh', function()
		sampAddChatMessage(tag .. "������� ����������: X - " .. sw .. " | Y - " .. sh, -1)
		sampAddChatMessage(tag .. "������ ������� ������������� ��� debug ���������� ���� ����.����������", -1)
	end)

    sampRegisterChatCommand("tool", function()
        elements.imgui.main_window[0] = not elements.imgui.main_window[0]
        elements.imgui.menu_selectable = 0
    end)

	sampRegisterChatCommand("connectanother", function()
		sampShowDialog(1, "����� �� ������ �������", "������ ����� ������", '1', '2')
	end)

    while true do
        wait(0)

		if elements.boolean.autologin[0] then  
			wait(10000)
			sampSendChat('/alogin ' .. u8:decode())
		end

		local result, button, _, _ = sampHasDialogRespond(0)
		if result then  
			if button == 1 then  
				config.settings.device = 'android'
				save()
				sampAddChatMessage(tag .. "������������� ���������� ��� Android.")
			elseif button == 0 then  
				config.settings.device = 'pc'
				save()
				sampAddChatMessage(tag .. "������������� ���������� ��� PC.")
			end  
		end

		local result, button, _, _ = sampHasDialogRespond(1)
		if result then  
			if button == 1 then  
				sampConnectToServer('46.174.52.246', 7777)
			elseif button == 0 then  
				sampConnectToServer('46.174.49.170', 7777)
			end 
		end
        
    end
end

-- ## ���� ������� � ������ ��������� ���� ## --
function cmd_flood(arg)
    if arg:find('(.+) (.+)') then
        arg1, arg2 = arg:match('(.+) (.+)')
        if arg2 == '1' then
		    sampSendChat("/mute " .. arg1 .. " 120 " .. " ����/���� ")
        elseif arg2 == '2' then  
            sampSendChat("/mute " .. arg1 .. " 240 " .. " ����/���� x2")
        elseif arg2 == '3' then  
            sampSendChat("/mute " .. arg1 .. " 360 " .. " ����/���� x3")
        elseif arg2 == '4' then  
            sampSendChat("/mute " .. arg1 .. " 480 " .. " ����/���� x4")
        elseif arg2 == '5' then  
            sampSendChat("/mute " .. arg1 .. " 600 " .. " ����/���� x5")
        elseif arg2 == '6' then  
            sampSendChat("/mute " .. arg1 .. " 720 " .. " ����/���� x6")
        elseif arg2 == '7' then  
            sampSendChat("/mute " .. arg1 .. " 840 " .. " ����/���� x7")
        elseif arg2 == '8' then  
            sampSendChat("/mute " .. arg1 .. " 960 " .. " ����/���� x8")
        elseif arg2 == '9' then  
            sampSendChat("/mute " .. arg1 .. " 1080 " .. " ����/���� x9")
        elseif arg2 == '10' then  
            sampSendChat("/mute " .. arg1 .. " 1200 " .. " ����/���� x10")
        end
	elseif arg:find('(.+)') then
        sampSendChat("/mute " .. arg .. " 120 " .. " ����/���� ")
    else
        sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
        sampAddChatMessage(tag .. " �����������: /fd [IDPlayer] [~��������� (�� 2 �� 10)]", -1)
	end
end


function cmd_popr(arg)
    if arg:find('(.+) (.+)') then
        arg1, arg2 = arg:match('(.+) (.+)')
        if arg2 == '1' then
		    sampSendChat("/mute " .. arg1 .. " 120 " .. " ���������������� ")
        elseif arg2 == '2' then  
            sampSendChat("/mute " .. arg1 .. " 240 " .. " ���������������� x2")
        elseif arg2 == '3' then  
            sampSendChat("/mute " .. arg1 .. " 360 " .. " ���������������� x3")
        elseif arg2 == '4' then  
            sampSendChat("/mute " .. arg1 .. " 480 " .. " ���������������� x4")
        elseif arg2 == '5' then  
            sampSendChat("/mute " .. arg1 .. " 600 " .. " ���������������� x5")
        elseif arg2 == '6' then  
            sampSendChat("/mute " .. arg1 .. " 720 " .. " ���������������� x6")
        elseif arg2 == '7' then  
            sampSendChat("/mute " .. arg1 .. " 840 " .. " ���������������� x7")
        elseif arg2 == '8' then  
            sampSendChat("/mute " .. arg1 .. " 960 " .. " ���������������� x8")
        elseif arg2 == '9' then  
            sampSendChat("/mute " .. arg1 .. " 1080 " .. " ���������������� x9")
        elseif arg2 == '10' then  
            sampSendChat("/mute " .. arg1 .. " 1200 " .. " ���������������� x10")
        end
	elseif arg:find('(.+)') then
        sampSendChat("/mute " .. arg .. " 120 " .. " ���������������� ")
    else
        sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
        sampAddChatMessage(tag .. " �����������: /po [IDPlayer] [~��������� (�� 2 �� 10)]", -1)
	end
end

-- ## ���� ������� � ������ ������-��������� ���� ## --
function cmd_rup(arg)
	if #arg > 0 then
		sampSendChat("/rmute " .. arg .. " 1000 " .. " ���������� ��������� ��������. ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_ror(arg)
	if #arg > 0 then
		sampSendChat("/rmute " .. arg .. " 5000 " .. " �����������/���������� ������ ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_cpfd(arg)
    if arg:find('(.+) (.+)') then
        arg1, arg2 = arg:match('(.+) (.+)')
        if arg2 == '1' then
		    sampSendChat("/rmute " .. arg1 .. " 120 " .. " caps/offtop ")
        elseif arg2 == '2' then  
            sampSendChat("/rmute " .. arg1 .. " 240 " .. " caps/offtop x2")
        elseif arg2 == '3' then  
            sampSendChat("/rmute " .. arg1 .. " 360 " .. " caps/offtop x3")
        elseif arg2 == '4' then  
            sampSendChat("/rmute " .. arg1 .. " 480 " .. " caps/offtop x4")
        elseif arg2 == '5' then  
            sampSendChat("/rmute " .. arg1 .. " 600 " .. " caps/offtop x5")
        elseif arg2 == '6' then  
            sampSendChat("/rmute " .. arg1 .. " 720 " .. " caps/offtop x6")
        elseif arg2 == '7' then  
            sampSendChat("/rmute " .. arg1 .. " 840 " .. " caps/offtop x7")
        elseif arg2 == '8' then  
            sampSendChat("/rmute " .. arg1 .. " 960 " .. " caps/offtop x8")
        elseif arg2 == '9' then  
            sampSendChat("/rmute " .. arg1 .. " 1080 " .. " caps/offtop x9")
        elseif arg2 == '10' then  
            sampSendChat("/rmute " .. arg1 .. " 1200 " .. " caps/offtop x10")
        end
	elseif arg:find('(.+)') then
        sampSendChat("/rmute " .. arg .. " 120 " .. " caps/offtop ")
    else
        sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
        sampAddChatMessage(tag .. " �����������: /cp [IDPlayer] [~��������� (�� 2 �� 10)]", -1)
	end
end

function cmd_report_popr(arg)
    if arg:find('(.+) (.+)') then
        arg1, arg2 = arg:match('(.+) (.+)')
        if arg2 == '1' then
		    sampSendChat("/rmute " .. arg1 .. " 120 " .. " ���������������� ")
        elseif arg2 == '2' then  
            sampSendChat("/rmute " .. arg1 .. " 240 " .. " ���������������� x2")
        elseif arg2 == '3' then  
            sampSendChat("/rmute " .. arg1 .. " 360 " .. " ���������������� x3")
        elseif arg2 == '4' then  
            sampSendChat("/rmute " .. arg1 .. " 480 " .. " ���������������� x4")
        elseif arg2 == '5' then  
            sampSendChat("/rmute " .. arg1 .. " 600 " .. " ���������������� x5")
        elseif arg2 == '6' then  
            sampSendChat("/rmute " .. arg1 .. " 720 " .. " ���������������� x6")
        elseif arg2 == '7' then  
            sampSendChat("/rmute " .. arg1 .. " 840 " .. " ���������������� x7")
        elseif arg2 == '8' then  
            sampSendChat("/rmute " .. arg1 .. " 960 " .. " ���������������� x8")
        elseif arg2 == '9' then  
            sampSendChat("/rmute " .. arg1 .. " 1080 " .. " ���������������� x9")
        elseif arg2 == '10' then  
            sampSendChat("/rmute " .. arg1 .. " 1200 " .. " ���������������� x10")
        end
	elseif arg:find('(.+)') then
        sampSendChat("/rmute " .. arg .. " 120 " .. " ���������������� ")
    else
        sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
        sampAddChatMessage(tag .. " �����������: /rpo [IDPlayer] [~��������� (�� 2 �� 10)]", -1)
	end
end

function cmd_rm(arg)
	if #arg > 0 then
		sampSendChat("/rmute " .. arg .. " 300 " .. " ����������� �������. ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_roa(arg)
	if #arg > 0 then
		sampSendChat("/rmute " .. arg .. " 2500 " .. " ���/����.�������������  ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_report_neadekvat(arg)
    if arg:find('(.+) (.+)') then
        arg1, arg2 = arg:match('(.+) (.+)')
        if arg2 == '2' then
		    sampSendChat("/rmute " .. arg1 .. " 1800 " .. " ������������ ��������� x2")
        elseif arg2 == '3' then  
            sampSendChat("/rmute " .. arg1 .. " 3000 " .. " ������������ ��������� x3")
        elseif arg2 == '1' then  
            sampSendChat("/rmute " .. arg1 .. " 900 " .. " ������������ ���������")
        end
	elseif arg:find('(.+)') then
        sampSendChat("/rmute " .. arg .. " 900 " .. " ������������ ���������")
    else
        sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
        sampAddChatMessage(tag .. " �����������: /rnm [IDPlayer] [~��������� (�� 2-3)]", -1)
	end
end

function cmd_rok(arg)
	if #arg > 0 then
		sampSendChat("/rmute " .. arg .. " 400 " .. " �����������/��������. ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_rrz(arg)
	if #arg > 0 then 
		sampSendChat("/rmute " .. arg .. " 5000 " .. " ������ ������. �����")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end	
-- ## ���� ������� � ������ ������-��������� ���� ## --

-- ## ���� ������� � ������ offline-��������� ���� ## --
function cmd_azs(arg)
	if #arg > 0 then  
		sampSendChat("/muteakk"  .. arg .. " 600 " .. " �����.���������")
	else  
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end 
end		

function cmd_afd(arg)
	if #arg > 0 then
		sampSendChat("/muteakk " .. arg .. " 120 " .. " ����/����")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_apo(arg)
	if #arg > 0 then
		sampSendChat("/muteakk " .. arg .. " 120 " .. " ���������������� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_am(arg)
	if #arg > 0 then
		sampSendChat("/muteakk " .. arg .. " 300 " .. " ����������� �������.")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_aok(arg)
	if #arg > 0 then
		sampSendChat("/muteakk " .. arg .. " 400 " .. " �����������/��������. ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_offline_neadekvat(arg)
    if arg:find('(.+) (.+)') then
        arg1, arg2 = arg:match('(.+) (.+)')
        if arg2 == '2' then
		    sampSendChat("/muteakk " .. arg1 .. " 1800 " .. " ������������ ��������� x2")
        elseif arg2 == '3' then  
            sampSendChat("/muteakk " .. arg1 .. " 3000 " .. " ������������ ��������� x3")
        elseif arg2 == '1' then  
            sampSendChat("/muteakk " .. arg1 .. " 900 " .. " ������������ ���������")
        end
	elseif arg:find('(.+)') then
        sampSendChat("/muteakk " .. arg .. " 900 " .. " ������������ ���������")
    else
        sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
        sampAddChatMessage(tag .. " �����������: /anm [IDPlayer] [~��������� (�� 2-3)]", -1)
	end
end


function cmd_aoa(arg)
	if #arg > 0 then
		sampSendChat("/muteakk " .. arg .. " 2500 " .. " ���/����.������������� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_aor(arg)
	if #arg > 0 then
		sampSendChat("/muteakk " .. arg .. " 5000 " .. " �����������/���������� ������ ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_aup(arg)
	if #arg > 0 then
		sampSendChat("/muteakk " .. arg .. " 1000 " .. " ���������� ����� ������� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end 

function cmd_aia(arg)
	if #arg > 0 then
		sampSendChat("/muteakk " .. arg .. " 2500 " .. " ������ ���� �� �������������� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_akl(arg)
	if #arg > 0 then
		sampSendChat("/muteakk " .. arg .. " 3000 " .. " ������� �� ������������� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_arz(arg)
	if #arg > 0 then
		sampSendChat("/muteakk " .. arg .. " 5000 " .. " ������ ������. ����� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end	
-- ## ���� ������� � ������ offline-��������� ���� ## --

-- ## ���� ������� � ������ ��������� ������ ## -- 
function cmd_sk(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 300 " .. " Spawn Kill")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_dz(arg)
    if arg:find('(.+) (.+)') then
        arg1, arg2 = arg:match('(.+) (.+)')
        if arg2 == '1' then
		    sampSendChat("/jail " .. arg1 .. " 300 " .. " DM/DB in zz ")
        elseif arg2 == '2' then  
            sampSendChat("/jail " .. arg1 .. " 600 " .. " DM/DB in zz x2")
        elseif arg2 == '3' then  
            sampSendChat("/jail " .. arg1 .. " 900 " .. " DM/DB in zz x3")
        elseif arg2 == '4' then  
            sampSendChat("/jail " .. arg1 .. " 1200 " .. " DM/DB in zz x4")
        elseif arg2 == '5' then  
            sampSendChat("/jail " .. arg1 .. " 1500 " .. " DM/DB in zz x5")
        elseif arg2 == '6' then  
            sampSendChat("/jail " .. arg1 .. " 1800 " .. " DM/DB in zz x6")
        elseif arg2 == '7' then  
            sampSendChat("/jail " .. arg1 .. " 2100 " .. " DM/DB in zz x7")
        elseif arg2 == '8' then  
            sampSendChat("/jail " .. arg1 .. " 2400 " .. " DM/DB in zz x8")
        elseif arg2 == '9' then  
            sampSendChat("/jail " .. arg1 .. " 2700 " .. " DM/DB in zz x9")
        elseif arg2 == '10' then  
            sampSendChat("/jail " .. arg1 .. " 3000 " .. " DM/DB in zz x10")
        end
	elseif arg:find('(.+)') then
        sampSendChat("/jail " .. arg .. " 120 " .. " DM/DB in zz ")
    else
        sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
        sampAddChatMessage(tag .. " �����������: /dz [IDPlayer] [~��������� (�� 2 �� 10)]", -1)
	end
end

function cmd_td(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 300 " .. " DB/car in trade ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_jm(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 300 " .. " ��������� ������ �� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_pmx(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 300 " .. " ��������� ������ ������� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_skw(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 600 " .. " SK in /gw ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_dgw(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 500 " .. " ������������� ���������� in /gw ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_ngw(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 600 " .. " ������������� ����������� ������ in /gw ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_dbgw(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 600 " .. " ������������� ��������� in /gw ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_fsh(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 900 " .. " ������������� SpeedHack/FlyCar ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_bag(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 300 " .. " ������� ������ (deagle in car)")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_pk(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 900 " .. " ������������� ������ ���� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_jch(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 3000 " .. " ������������� ���������� �������/�� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_zv(arg)
	if #arg > 0 then
		sampSendChat("/jail " ..  arg .. " 3000 " .. " ��������������� VIP`om ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_sch(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 900 " .. " ������������� ����������� �������� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_jcw(arg)
	if #arg > 0 then
		sampSendChat("/jail " .. arg .. " 900 " .. " ������������� ClickWarp/Metla (���)")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_tdbz(arg)
	if #arg > 0 then  
		sampSendChat("/jail " .. arg .. " 900 " .. " �� � ������ (zz)")
	else  
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)	
	end 
end	
-- ## ���� ������� � ������ ��������� ������ ## -- 

-- ## ���� ������� � ������ offline-��������� ������ ## -- 
function cmd_asch(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 900 " .. " ������������� ����������� �������� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_ajch(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 3000 " .. " ������������� ���������� �������/�� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_azv(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " ..  arg .. " 3000 " .. " ��������������� VIP`om ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_adgw(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 500 " .. " ������������� ���������� in /gw ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_ask(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 300 " .. " SpawnKill ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_adz(arg)
    if arg:find('(.+) (.+)') then
        arg1, arg2 = arg:match('(.+) (.+)')
        if arg2 == '1' then
		    sampSendChat("/prisonakk " .. arg1 .. " 300 " .. " DM/DB in zz ")
        elseif arg2 == '2' then  
            sampSendChat("/prisonakk " .. arg1 .. " 600 " .. " DM/DB in zz x2")
        elseif arg2 == '3' then  
            sampSendChat("/prisonakk " .. arg1 .. " 900 " .. " DM/DB in zz x3")
        elseif arg2 == '4' then  
            sampSendChat("/prisonakk " .. arg1 .. " 1200 " .. " DM/DB in zz x4")
        elseif arg2 == '5' then  
            sampSendChat("/prisonakk " .. arg1 .. " 1500 " .. " DM/DB in zz x5")
        elseif arg2 == '6' then  
            sampSendChat("/prisonakk " .. arg1 .. " 1800 " .. " DM/DB in zz x6")
        elseif arg2 == '7' then  
            sampSendChat("/prisonakk " .. arg1 .. " 2100 " .. " DM/DB in zz x7")
        elseif arg2 == '8' then  
            sampSendChat("/prisonakk " .. arg1 .. " 2400 " .. " DM/DB in zz x8")
        elseif arg2 == '9' then  
            sampSendChat("/prisonakk " .. arg1 .. " 2700 " .. " DM/DB in zz x9")
        elseif arg2 == '10' then  
            sampSendChat("/prisonakk " .. arg1 .. " 3000 " .. " DM/DB in zz x10")
        end
	elseif arg:find('(.+)') then
        sampSendChat("/prisonakk " .. arg .. " 120 " .. " DM/DB in zz ")
    else
        sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
        sampAddChatMessage(tag .. " �����������: /adz [IDPlayer] [~��������� (�� 2 �� 10)]", -1)
	end
end

function cmd_atd(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 300 " .. " DB/car in trade ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_ajm(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 300 " .. " ��������� ������ �� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_apmx(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 300 " .. " ��������� ������ ������� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_askw(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 600 " .. " SK in /gw ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_angw(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 600 " .. " ������������� ����������� ������ in /gw ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_adbgw(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 600 " .. " db-����, �������� � ���/����/����� in /gw ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_afsh(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 900 " .. " ������������� SpeedHack/FlyCar ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_abag(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 300 " .. " ������� ������ (deagle in car)")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_apk(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 900 " .. " ������������� ������ ���� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end

function cmd_ajcw(arg)
	if #arg > 0 then
		sampSendChat("/prisonakk " .. arg .. " 900 " .. " ������������� ClickWarp/Metla (���)")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NICK ����������! ", -1)
	end
end
-- ## ���� ������� � ������ offline-��������� ������ ## -- 

-- ## ���� ������� � ������ ��������� ���� ## -- 
function cmd_hl(arg)
	if #arg > 0 then
		sampSendChat("/ans " .. arg .. " ��������� �����, �� �������� ������� �������, � ���� ��..")
		sampSendChat("/ans " .. arg .. " ..�� �������� � ����������, �������� ������ �� ����� https://forumrds.ru")
		sampSendChat("/iban " .. arg .. " 3 " .. " �����������/��������/��� � �������")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)	
	end
end

function cmd_pl(arg)
	if #arg > 0 then
		sampSendChat("/ans " .. arg .. " ��������� �����, �� �������� ������� �������, � ���� ��..")
		sampSendChat("/ans " .. arg .. " ..�� �������� � ����������, �������� ������ �� ����� https://forumrds.ru")
		sampSendChat("/ban " .. arg .. " 7 " .. " ������� ���� �������������� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_ob(arg)
	if #arg > 0 then
		sampSendChat("/ans " .. arg .. " ��������� �����, �� �������� ������� �������, � ���� ��..")
		sampSendChat("/ans " .. arg .. " ..�� �������� � ����������, �������� ������ �� ����� https://forumrds.ru")
		sampSendChat("/iban " .. arg .. " 7 " .. " ����� �������� ���� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end 	

function cmd_gcnk(arg)
	if #arg > 0 then
		sampSendChat("/ans " .. arg .. " ��������� �����, �� �������� ������� �������, � ���� ��..")
		sampSendChat("/ans " .. arg .. " ..�� �������� � ����������, �������� ������ �� ����� https://forumrds.ru")
		sampSendChat("/iban " .. arg .. " 7 " .. " �����, ���������� ����������� ������� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_menk(arg)
	if #arg > 0 then
		sampSendChat("/ans " .. arg .. " ��������� �����, �� �������� ������� �������, � ���� ��..")
		sampSendChat("/ans " .. arg .. " ..�� �������� � ����������, �������� ������ �� ����� https://forumrds.ru")
		sampSendChat("/ban " .. arg .. " 7 " .. " ���, ����������� ����������� ����� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_nk(arg)
	if #arg > 0 then
		sampSendChat("/ans " .. arg .. " ��������� �����, �� �������� ������� �������, � ���� ��..")
		sampSendChat("/ans " .. arg .. " ..�� �������� � ����������, �������� ������ �� ����� https://forumrds.ru")
		sampSendChat("/ban " .. arg .. " 7 " .. " ���, ���������� ����������� ������� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_bnm(arg)
	if #arg > 0 then
		sampSendChat("/ans " .. arg .. " ��������� �����, �� �������� ������� �������, � ���� ��..")
		sampSendChat("/ans " .. arg .. " ..�� �������� � ����������, �������� ������ �� ����� https://forumrds.ru")
		sampSendChat("/iban " .. arg .. " 7 " .. " ������������ ���������")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end	
-- ## ���� ������� � ������ ��������� ���� ## -- 

-- ## ���� ������� � ������ offline-��������� ���� ## --
function cmd_amenk(arg)
	if #arg > 0 then
		sampSendChat("/banakk " .. arg .. " 7 " .. " ���, ����������� ����������� ����� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NickName ����������! ", -1)
	end
end


function cmd_ahl(arg)
	if #arg > 0 then
		sampSendChat("/offban " .. arg .. " 3 " .. " ���/��������/��� � �������")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NickName ����������! ", -1)
	end
end

function cmd_ahli(arg)
	if #arg > 0 then
		sampSendChat("/banip " .. arg .. " 3 " .. " ���/��������/��� � �������")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ IP ����������! ", -1)
	end
end

function cmd_aob(arg)
	if #arg > 0 then
		sampSendChat("/offban " .. arg .. " 7 " .. " ����� ���� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NickName ����������! ", -1)
	end
end

function cmd_apl(arg)
	if #arg > 0 then
		sampSendChat("/offban " .. arg .. " 7 " .. " ������� �������� ��������������")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NickName ����������! ", -1)
	end
end

function cmd_ach(arg)
	if #arg > 0 then
		sampSendChat("/offban " .. arg .. " 7 " .. "  ������������� ���������� �������/�� ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NickName ����������! ", -1)
	end
end

function cmd_achi(arg)
	if #arg > 0 then
		sampSendChat("/banip " .. arg .. " 7 " .. " ���/�� (ip) ") 
	else 
		sampAddChatMessage(tag .. "�� ������ ������ IP ����������! ", -1)
	end
end

function cmd_ank(arg)
	if #arg > 0 then
		sampSendChat("/banakk " .. arg .. " 7 " .. " ���, ���������� ������������ ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NickName ����������! ", -1)
	end
end

function cmd_agcnk(arg)
	if #arg > 0 then
		sampSendChat("/banakk " .. arg .. " 7 " .. " �����, �������� ������������")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NickName ����������! ", -1)
	end
end

function cmd_agcnkip(arg)
	if #arg > 0 then
		sampSendChat("/banip " .. arg .. " 7 "  .. " �����, �������� ������������ (ip)")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ IP ����������! ", -1)
	end
end

function cmd_rdsob(arg)
	if #arg > 0 then
		sampSendChat("/banakk " .. arg .. " 30 " .. " ����� �������������/�������")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ NickName ����������! ", -1)
	end
end	

function cmd_rdsip(arg)
	if #arg > 0 then
		sampSendChat("/banip " .. arg .. " 30 " .. " ����� �������������/�������")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ IP ����������! ", -1)
	end
end	

function cmd_abnm(arg)
	if #arg > 0 then
		sampSendChat("/banakk " .. arg .. " 7 " .. " ������������ ���������")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ IP ����������! ", -1)
	end
end	
-- ## ���� ������� � ������ offline-��������� ���� ## --

-- ## ���� ������� � ������ ��������� ���� ## --
function cmd_dj(arg)
	if #arg > 0 then
		sampSendChat("/kick " .. arg .. " DM in Jail ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end

function cmd_gnk(arg)
    if arg:find('(.+) (.+)') then
        arg1, arg2 = arg:match('(.+) (.+)')
        if arg2 == '1' then
		    sampSendChat("/kick " .. arg1 .. " ������� �������. 1/3 ")
        elseif arg2 == '2' then  
            sampSendChat("/kick " .. arg1 .. " ������� �������. 2/3")
        elseif arg2 == '3' then  
            sampSendChat("/kick " .. arg1 .. " ������� �������. 3/3")
        end
	elseif arg:find('(.+)') then
        sampSendChat("/kick " .. arg .. " ������� �������. 1/3 ")
    else
        sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
        sampAddChatMessage(tag .. " �����������: /gnk [IDPlayer] [~��������� (�� 2 �� 10)]", -1)
	end
end

function cmd_cafk(arg)
	if #arg > 0 then
		sampSendChat("/kick " .. arg .. " AFK in /arena ")
	else 
		sampAddChatMessage(tag .. "�� ������ ������ ID ����������! ", -1)
	end
end
-- ## ���� ������� � ������ ��������� ���� ## --

-- ## ���� ������� � ��������������� �������� ## --
function cmd_u(arg)
	sampSendChat("/unmute " .. arg)
end  

function cmd_uu(arg)
    lua_thread.create(function()
        sampSendChat("/unmute " .. arg)
        
        sampSendChat("/ans " .. arg .. " ���������� �� ������, ��������� �����. �������� ����")
    end)
end

function cmd_uj(arg)
    lua_thread.create(function()
        sampSendChat("/unjail " .. arg)
        
        sampSendChat("/ans " .. arg .. " ���������� �� ������, ��������� �����. �������� ����")
    end)
end

function cmd_stw(arg)
	sampSendChat("/setweap " .. arg .. " 38 5000 ")
end  

function cmd_as(arg)
	sampSendChat("/aspawn " .. arg)
end

function cmd_ru(arg)
    lua_thread.create(function()
	    sampSendChat("/rmute " .. arg .. " 5 " .. "  Mistake/������")
        
	    sampSendChat("/ans " .. arg .. " ���������� �� ������, ��������� �����. �������� ����.")
    end)
end
-- ## ���� ������� � ��������������� �������� ## --

-- ## ������� ��� ���������� ������ ## --
function textSplit(str, delim, plain)
    local tokens, pos, plain = {}, 1, not (plain == false) --[[ delimiter is plain text by default ]]
    repeat
        local npos, epos = string.find(str, delim, pos, plain)
        table.insert(tokens, string.sub(str, pos, npos and npos - 1))
        pos = epos and epos + 1
    until not pos
    return tokens
end
-- ## ������� ��� ���������� ������ ## --

-- ## �������� ������� ������ ## -- 
function loadRecon()
    wait(3000)
    accept_load_recon = true
end

function sampev.onShowTextDraw(id, data)
    if elements.boolean.recon[0] then 
        for _, i in pairs(ids_recon) do  
            if id == i then  
                return false  
            end 
        end
		if id == 2059 then  
			return false  
		end
    end
end

function sampev.onTextDrawSetString(id, text) 
    if (id == 2056 or id == 2059) and elements.boolean.recon[0] then  
        info_to_player = textSplit(text, "~n~")
    end
end

function sampev.onSendCommand(command)
    id = string.match(command, "/re (%d+)")
    if id ~= nil then  
        control_to_player = true  
        if control_to_player then  
            load_recon:run()

            elements.imgui.recon_window[0] = true 
        end 
        recon_id = id
    end
    if command == '/reoff' then  
        control_to_player = false  
        elements.imgui.recon_window[0] = false  
        recon_id = -1
    end
end
-- ## �������� ������� ������ ## -- 


local ReconWindow = imgui.OnFrame(
    function() return elements.imgui.recon_window[0] end, 
    function(player)
        
        royalblue()

        imgui.SetNextWindowPos(imgui.ImVec2(sw / 6, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(100, 300), imgui.Cond.FirstUseEver)

        imgui.LockPlayer = false  

        imgui.Begin("reconmenu", elements.imgui.recon_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoResize)
            if control_to_player then  
                
                if imgui.Button(u8"����������") then  
                    sampSendChat('/aspawn' .. recon_id)
                end
                if imgui.Button(u8"��������") then  
                    sampSendClickTextdraw(156)
                end
                if imgui.Button(u8"��������") then  
                    sampSendChat("/slap " .. recon_id)
                end
                if imgui.Button(u8"����������\n�����������") then  
                    sampSendChat("/freeze " .. recon_id)
                end
                if imgui.Button(u8"�����") then
                    sampSendChat("/reoff ")
                    control_to_player = false
                    elements.imgui.recon_window[0] = false
                end
            end
        imgui.End()

        if right_recon[0] then  
            imgui.SetNextWindowPos(imgui.ImVec2(sw - 200, sh - 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(400, 600), imgui.Cond.FirstUseEver)

            imgui.Begin(u8"���������� �� ������", nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
                recon_nick = sampGetPlayerNickname(recon_id)
                imgui.Text(u8"�����: ")
                imgui.Text(recon_nick)
                imgui.SameLine()
                imgui.Text('[' .. recon_id .. ']')
                imgui.Separator()
                for key, v in pairs(info_to_player) do  
                    if key == 1 then  
                        imgui.Text(u8:encode(recon_info[1]) .. " " .. info_to_player[1])
                        mim_addons.BufferingBar(tonumber(info_to_player[1])/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
                    end
                    if key == 2 and tonumber(info_to_player[2]) ~= 0 then
                        imgui.Text(u8:encode(recon_info[2]) .. " " .. info_to_player[2])
                        mim_addons.BufferingBar(tonumber(info_to_player[2])/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
                    end
                    if key == 3 and tonumber(info_to_player[3]) ~= -1 then
                        imgui.Text(u8:encode(recon_info[3]) .. " " .. info_to_player[3])
                        mim_addons.BufferingBar(tonumber(info_to_player[3])/1000, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
                    end
                    if key == 4 then
                        imgui.Text(u8:encode(recon_info[4]) .. " " .. info_to_player[4])
                        local speed, const = string.match(info_to_player[4], "(%d+) / (%d+)")
                        if tonumber(speed) > tonumber(const) then
                            speed = const
                        end
                        mim_addons.BufferingBar((tonumber(speed)*100/tonumber(const))/100, imgui.ImVec2(imgui.GetWindowWidth()-10, 10), false)
                    end
                    if key ~= 1 and key ~= 2 and key ~= 3 and key ~= 4 then
                        imgui.Text(u8:encode(recon_info[key]) .. " " .. info_to_player[key])
                    end
                end
            imgui.End()
        end
    end
)

local helloText = [[
��������� AT ��� ������ �������������.
����� ��� ������, ������������ �����
���� ���������� � �� ������.
]]

local textToMenuSelectableAutoMute = [[
������ ������� ��������� ��������� ������� ��� ���� 
�����.
�� ������ �������� ������ �����, ����������� 
������ ����������� ������ � �������� ���� ����.
]]

local MainWindowAT = imgui.OnFrame(
    function() return elements.imgui.main_window[0] end,
    function(player) 

        royalblue()

        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(1000, 600), imgui.Cond.FirstUseEver)

        imgui.Begin(fa.SERVER .. " [AT for Android]", elements.imgui.main_window, imgui.WindowFlags.NoResize) 
			imgui.BeginChild('##MenuLeft', imgui.ImVec2(300, 552), true)

				if imgui.Button(fa.HOUSE .. u8" �����������") then  
					elements.imgui.menu_selectable = 0
				end

                if imgui.Button(fa.USER_GEAR .. u8" �������� �������") then 
                    elements.imgui.menu_selectable = 1 
                end
				if imgui.Button(fa.BOOK .. u8" ��������� ��������") then  
					elements.imgui.menu_selectable = 2
				end

			imgui.EndChild()

			imgui.SameLine()
            
			imgui.BeginChild('##MainWindowRight', imgui.ImVec2(670, 552), true)
				if elements.imgui.menu_selectable == 0 then  
					imgui.Text(u8(helloText))
				end
				
				if elements.imgui.menu_selectable == 1 then  
					imgui.Text(u8"��������� �����-����")
					imgui.SameLine()
					if mim_addons.ToggleButton("##CustomReconMenu", elements.boolean.recon) then  
						config.settings.custom_recon = elements.boolean.recon[0]
						save() 
					end
				end

				if elements.imgui.menu_selectable == 2 then  
					imgui.Text(u8(textToMenuSelectableAutoMute))
				end
			imgui.EndChild()
        imgui.End()
    end
)

function royalblue()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2

	style.WindowPadding       = ImVec2(4, 6)
	style.WindowRounding      = 0
	style.ChildRounding = 3
	style.FramePadding        = ImVec2(5, 4)
	style.FrameRounding       = 2
	style.ItemSpacing         = ImVec2(3, 3)
	style.TouchExtraPadding   = ImVec2(0, 0)
	style.IndentSpacing       = 21
	style.ScrollbarSize       = 14
	style.ScrollbarRounding   = 16
	style.GrabMinSize         = 10
	style.GrabRounding        = 5
	style.WindowTitleAlign    = ImVec2(0.50, 0.50)
	style.ButtonTextAlign     = ImVec2(0, 0)

	colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled] = ImVec4(0.60, 0.60, 0.60, 1.00)
	colors[clr.WindowBg] = ImVec4(0.11, 0.10, 0.11, 1.00)
	colors[clr.ChildBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.PopupBg] = ImVec4(0.30, 0.30, 0.30, 1.00)
	colors[clr.Border] = ImVec4(0.86, 0.86, 0.86, 1.00)
	colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg] = ImVec4(0.21, 0.20, 0.21, 0.60)
	colors[clr.FrameBgHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.TitleBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.TitleBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.MenuBarBg] = ImVec4(0.01, 0.26, 0.37, 1.00)
	colors[clr.ScrollbarBg] = ImVec4(0.00, 0.46, 0.65, 0.00)
	colors[clr.ScrollbarGrab] = ImVec4(0.00, 0.46, 0.65, 0.44)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.00, 0.46, 0.65, 0.74)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.CheckMark] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.SliderGrab] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.SliderGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.Button] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.ButtonActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.Header] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.HeaderHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.HeaderActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.ResizeGrip] = ImVec4(1.00, 1.00, 1.00, 0.30)
	colors[clr.ResizeGripHovered] = ImVec4(1.00, 1.00, 1.00, 0.60)
	colors[clr.ResizeGripActive] = ImVec4(1.00, 1.00, 1.00, 0.90)
	colors[clr.PlotLines] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.PlotLinesHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.PlotHistogram] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.PlotHistogramHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.TextSelectedBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.ModalWindowDimBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
end