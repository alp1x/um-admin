const adminPanel = Vue.createApp({
    data() {
        return {
            lang: UMAdmin.Lang,
            configsettings: UMAdmin.Settings,
            steamapi: UMAdmin.Settings.steamWebAPI,
            dashboard: true,
            allplayers: [],
            search: "",
            players: false,
            panel: false,
            totalonline: "",
            playersprofile: false,
            ppdata: [],
            pedsModel: UMAdmin.PlayerModels,
            peds: false,
            discord: {
                name: "",
                avatar: "",
                banner: ""
            },
            steam: {
                name: "",
                avatar: "",
            },
            announce: "",
            minpage: false,
            server: false,
            vehicles: [],
            vehpage: false,
            totalcash: "view totalcash",
            totalbank: "view totalbank",
            selected: null,
            vehiclelist: [],
            weapons: [],
            vehlist: false,
            reason: "",
            kick: false,
            ban: false,
            perm: false,
            selectedBan: "",
            selectedPerm: "",
            setped: false,
            setmoney: false,
            modeltype: "",
            moneytotal: "",
            moneytypes: "",
            weaponspage: false,
            togglemute: false,
            devs: false,
            distance: 5,
        }
    },
    methods: {
        async fetchNui(eventName, data) {
            const resource = GetParentResourceName();
            const response  = await fetch(`https://${resource}/${eventName}`, {
                method: 'post',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify(data),
            });
            return await response.json();
        },
        copyToClipboard(text) {
            const el = document.createElement('textarea');
            el.value = text;
            document.body.appendChild(el);
            el.select();
            document.execCommand('copy');
            document.body.removeChild(el);
        },
        minPage(panel,minPage,devs,callBack) {
	   this.panel = panel
	   this.minpage = minPage
       	   this.devs = devs
	   this.fetchNui(`um-admin:nuicallback:${callBack}`, '')
        },
        pageResetEvent(url, pageReset, data) {
            this.fetchNui(url, data)
            this.pageReset(pageReset)
        },
        getVehicleList(k) {
            this.vehiclelist = k
            this.pageReset('vehlist')
        },
        actionEvent(data) {
            this.fetchNui('um-admin:nuicallback:event', data)
        },
        weaponNameUpperCase(name) {
            return `https://vespura.com/fivem/weapons/images/${name.toUpperCase()}.png`
        },
        noImageError(e) {
            e.target.src = 'assets/img/no-image.jpg'
        },
        setDistance() {
            if (this.distance < 50) {
                this.distance += 5
            } else {
                this.distance = 5
            }
            this.fetchNui('qb-admin:client:viewdistance',this.distance)
        },
        keyupHandler(e) {
            if (e.key == "Escape") {
                this.minpage = false;
                this.devs = false;
                this.panel = false;
                this.fetchNui('um-admin:nuicallback:escapeNui', '')
            } else if (e.which == 32) {
                e.preventDefault();
            }
        },
        eventHandler(e) {
            const d = e.data
            switch (d.type) {
                case "panel":
                    this.totalonline = d.result,
                    this.panel = true
                    break;
                case "getplayers":
                    this.allplayers = d.players
                    break;
                case "playerprofile":
                    this.ppdata = d.data
                    fetch(`https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=${this.configsettings.steamWebAPI}&steamids=${d.data.steampic}`)
                    .then(response => response.json())
                    .then((data) =>{
                        this.steam.avatar = data.response.players[0].avatar
                        this.steam.name = data.response.players[0].personaname
                    })
                    .catch(() =>  {
                        this.steam.avatar = "assets/img/no-image.jpg"
                        this.steam.name = "no steam"
                    });
                    fetch(`https://discordlookup.mesavirep.xyz/v1/user/${d.data.discordpic}`)
                    .then(response => response.json())
                    .then((data) =>{
                        this.discord.avatar = data.avatar["link"]
                        this.discord.banner = data.banner["link"]
                        this.discord.name = data.tag
                    })
                    .catch(() =>  {
                        this.discord.avatar = "assets/img/no-image.jpg"
                    //  this.discord.banner = "no-image.jpg"
                        this.discord.name = "no discord"
                    });
                        this.playersprofile = true
                    break;
                case "vehicles":
                    this.vehicles = d.vehicles
                    break;
                case "money":
                    const dollarUSLocale = Intl.NumberFormat('en-US');
                    let formatMoney = dollarUSLocale.format(d.totalmoney)
                    if (d.moneytype == 'cash') {
                        this.totalcash = formatMoney
                    } else {
                        this.totalbank = formatMoney
                    }
                    break;
                case "string":
                    this.copyToClipboard(d.string)
                    break;
                case "weapons":
                    this.weapons = d.weapons
                    break;
            }
        },
        pageReset(vari) {
            this.dashboard = false
            this.players = false
            this.server = false
            this.playersprofile = false
            this.vehpage = false
            this.vehlist = false
            this.peds = false
            this.weaponspage = false
            this[vari] = true
        },
        configControl() {
            switch (true) {
                case this.configsettings.pmaVoice:
                    this.togglemute = true 
                    break;
                case this.configsettings.opacity:
                    document.documentElement.style.setProperty("--black", "#0a0a0ab3");
                    break;
            }
        },
    },
    computed: {
        allPlayers() {
            return this.allplayers.filter(p => {
                return p.name.toLowerCase().indexOf(this.search.toLowerCase()) != -1 || p.id.toString().indexOf(this.search.toLowerCase()) != -1
            });
        }
    },
    mounted() {
        window.addEventListener('message', this.eventHandler);
        document.addEventListener('keyup', this.keyupHandler);
        this.configControl();
    },
    beforeUnmount() {
        window.removeEventListener('message', this.eventHandler);
        document.removeEventListener('keyup', this.keyupHandler);
    },
}).mount('body');
