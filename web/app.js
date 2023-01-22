const adminPanel = Vue.createApp({
    data() {
        return {
            lang: UMAdmin.Lang,
            steamapi: UMAdmin.SteamWebAPI,
            dashboard: true,
            allplayers: [],
            search: "",
            players: false,
            panel: false,
            totalonline: "",
            playersprofile: false,
            ppdata: [],
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
            isActive: false,
            server: false,
            vehicles: [],
            vehpage: false,
            totalcash: "view totalcash",
            totalbank: "view totalbank",
            selected: null,
            vehiclelist: [],
            vehlist: false,
            reason: "",
            kick: false,
            ban: false,
            perm: false,
            selectedBan: "",
            selectedPerm: "",
        }
    },
    methods: {
        async fetchNui(eventName, data) {
            const resource = GetParentResourceName();
            const resp = await fetch(`https://${resource}/${eventName}`, {
                method: 'post',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify(data),
            });
            return resp.json();
        },
        async fetchAsync(url) {
            const response = await fetch(url);
            return response.json();
        },
        copyToClipboard(text) {
            const el = document.createElement('textarea');
            el.value = text;
            document.body.appendChild(el);
            el.select();
            document.execCommand('copy');
            document.body.removeChild(el);
        },
        minPage(panel,minPage,callBack) {
			this.panel = panel
			this.minpage = minPage
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
        keyupHandler(e) {
            if (e.key == "Escape") {
                this.panel = false;
                this.minpage = false;
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
                    this.allplayers = d.players,
                        this.dashboard = false,
                        this.players = true
                    break;
                case "playerprofile":
                    this.ppdata = d.data
                    this.players = false
                    this.dashboard = false
                    this.fetchAsync(`https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=${this.steamapi}&steamids=${d.data.steampic}`)
                        .then((value) => {
                            this.steam.avatar = value.response.players[0].avatar
                            this.steam.name = value.response.players[0].personaname
                        })
                        .catch(() => {
                            this.steam.avatar = "no-image.jpg"
                            this.steam.name = "no steam"
                        });
                    this.fetchAsync(`https://discordlookup.mesavirep.xyz/v1/${d.data.discordpic}`)
                        .then((value) => {
                            this.discord.avatar = value.avatar["link"]
                            this.discord.banner = value.banner["link"]
                            this.discord.name = value.tag
                            this.playersprofile = true
                        })
                        .catch(() => {
                            this.discord.avatar = "no-image.jpg"
                            // this.discord.banner = "no-image.jpg"
                            this.discord.name = "no discord"
                            this.playersprofile = true
                        });
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
            }
        },
        pageReset(vari) {
            this.dashboard = false
            this.players = false
            this.server = false
            this.playersprofile = false
            this.vehpage = false
            this.vehlist = false
            this[vari] = true
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
    },
    beforeUnmount() {
        window.removeEventListener('message', this.eventHandler);
        document.removeEventListener('keyup', this.keyupHandler);
    },
}).mount('body')