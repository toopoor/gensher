! function() {
    for (var t, e = function() {}, i = ["assert", "clear", "count", "debug", "dir", "dirxml", "error", "exception", "group", "groupCollapsed", "groupEnd", "info", "log", "markTimeline", "profile", "profileEnd", "table", "time", "timeEnd", "timeline", "timelineEnd", "timeStamp", "trace", "warn"], n = i.length, s = window.console = window.console || {}; n--;) t = i[n], s[t] || (s[t] = e)
}(), ! function(t) {
    "use strict";
    "function" == typeof define && define.amd ? define(["jquery"], t) : "undefined" != typeof exports ? module.exports = t(require("jquery")) : t(jQuery)
}(function(t) {
    Date.now || (Date.now = function() {
        return (new Date).getTime()
    }), window.requestAnimationFrame || function() {
        "use strict";
        for (var t = ["webkit", "moz"], e = 0; e < t.length && !window.requestAnimationFrame; ++e) {
            var i = t[e];
            window.requestAnimationFrame = window[i + "RequestAnimationFrame"], window.cancelAnimationFrame = window[i + "CancelAnimationFrame"] || window[i + "CancelRequestAnimationFrame"]
        }
        if (/iP(ad|hone|od).*OS 6/.test(window.navigator.userAgent) || !window.requestAnimationFrame || !window.cancelAnimationFrame) {
            var n = 0;
            window.requestAnimationFrame = function(t) {
                var e = Date.now(),
                    i = Math.max(n + 16, e);
                return setTimeout(function() {
                    t(n = i)
                }, i - e)
            }, window.cancelAnimationFrame = clearTimeout
        }
    }();
    var e = function() {
            for (var t = "transform WebkitTransform MozTransform OTransform msTransform".split(" "), e = document.createElement("div"), i = 0; i < t.length; i++)
                if (e && void 0 !== e.style[t[i]]) return t[i];
            return !1
        }(),
        i = function() {
            if (!window.getComputedStyle) return !1;
            var t, e = document.createElement("p"),
                i = {
                    webkitTransform: "-webkit-transform",
                    OTransform: "-o-transform",
                    msTransform: "-ms-transform",
                    MozTransform: "-moz-transform",
                    transform: "transform"
                };
            (document.body || document.documentElement).insertBefore(e, null);
            for (var n in i) void 0 !== e.style[n] && (e.style[n] = "translate3d(1px,1px,1px)", t = window.getComputedStyle(e).getPropertyValue(i[n]));
            return (document.body || document.documentElement).removeChild(e), void 0 !== t && t.length > 0 && "none" !== t
        }(),
        n = navigator.userAgent.toLowerCase().indexOf("android") > -1,
        s = [],
        r = function() {
            function e(e, r) {
                var a, o = this;
                o.$item = t(e), o.defaults = {
                    speed: .5,
                    imgSrc: null,
                    imgWidth: null,
                    imgHeight: null,
                    enableTransform: !0,
                    zIndex: -100
                }, a = o.$item.data("jarallax") || {}, o.options = t.extend({}, o.defaults, a, r), o.options.speed = Math.min(1, Math.max(0, parseFloat(o.options.speed))), o.instanceID = i++, o.image = {
                    src: o.options.imgSrc || null,
                    $container: null,
                    $item: null,
                    width: o.options.imgWidth || null,
                    height: o.options.imgHeight || null,
                    useImgTag: n
                }, o.initImg() && (o.init(), s.push(o))
            }
            var i = 0;
            return e
        }();
    r.prototype.initImg = function() {
            var t = this;
            return null === t.image.src && (t.image.src = t.$item.css("background-image").replace(/^url\(['"]?/g, "").replace(/['"]?\)$/g, "")), t.image.src && "none" !== t.image.src ? !0 : !1
        }, r.prototype.init = function() {
            var e = this,
                i = {
                    position: "absolute",
                    top: 0,
                    left: 0,
                    width: "100%",
                    height: "100%",
                    overflow: "hidden",
                    "pointer-events": "none",
                    transition: "transform linear -1ms, -webkit-transform linear -1ms"
                },
                n = {
                    position: "fixed"
                };
            e.image.$container = t("<div>").css(i).css({
                visibility: "hidden",
                "z-index": e.options.zIndex
            }).attr("id", "jarallax-container-" + e.instanceID).prependTo(e.$item), e.image.useImgTag ? (e.image.$item = t("<img>").attr("src", e.image.src), n = t.extend({}, i, n)) : (e.image.$item = t("<div>"), n = t.extend({
                "background-position": "50% 50%",
                "background-repeat": "no-repeat no-repeat",
                "background-image": "url(" + e.image.src + ")"
            }, i, n)), e.image.$item.css(n).prependTo(e.image.$container), e.getImageSize(e.image.src, function(t, i) {
                e.image.width = t, e.image.height = i, window.requestAnimationFrame(function() {
                    e.coverImage(), e.clipContainer(), e.onScroll()
                }), e.$item.data("jarallax-original-styles", e.$item.attr("style")), setTimeout(function() {
                    e.$item.css({
                        "background-image": "none",
                        "background-attachment": "scroll",
                        "background-size": "auto"
                    })
                }, 0)
            })
        }, r.prototype.destroy = function() {
            for (var e = this, i = 0, n = s.length; n > i; i++)
                if (s[i].instanceID === e.instanceID) {
                    s.splice(i, 1);
                    break
                }
            t("head #jarallax-clip-" + e.instanceID).remove(), e.$item.attr("style", e.$item.data("jarallax-original-styles")), e.$item.removeData("jarallax-original-styles"), e.image.$container.remove(), delete e.$item[0].jarallax
        }, r.prototype.round = function(t) {
            return Math.floor(100 * t) / 100
        }, r.prototype.getImageSize = function(t, e) {
            if (!t || !e) return !1;
            var i = new Image;
            i.onload = function() {
                e(i.width, i.height)
            }, i.src = t
        }, r.prototype.clipContainer = function() {
            var e = this,
                i = e.image.$container.outerWidth(!0),
                n = e.image.$container.outerHeight(!0),
                s = t("head #jarallax-clip-" + e.instanceID);
            s.length || (t("head").append('<style type="text/css" id="jarallax-clip-' + e.instanceID + '"></style>'), s = t("head #jarallax-clip-" + e.instanceID));
            var r = ["#jarallax-container-" + e.instanceID + " {", "   clip: rect(0px " + i + "px " + n + "px 0);", "   clip: rect(0px, " + i + "px, " + n + "px, 0);", "}"].join("\n");
            s[0].styleSheet ? s[0].styleSheet.cssText = r : s.html(r)
        }, r.prototype.coverImage = function() {
            var e = this;
            if (e.image.width && e.image.height) {
                var i, n, s = e.image.$container.outerWidth(!0),
                    r = e.image.$container.outerHeight(!0),
                    a = t(window).outerWidth(!0),
                    o = t(window).outerHeight(!0),
                    l = e.image.width,
                    u = e.image.height,
                    c = {
                        width: Math.max(a, s) * Math.max(e.options.speed, 1),
                        height: Math.max(o, r) * Math.max(e.options.speed, 1)
                    };
                c.width / c.height > l / u ? (i = c.width, n = c.width * u / l) : (i = c.height * l / u, n = c.height), e.image.useImgTag ? (c.width = e.round(i), c.height = e.round(n), c.marginLeft = e.round(-(i - s) / 2), c.marginTop = e.round(-(n - r) / 2)) : c.backgroundSize = e.round(i) + "px " + e.round(n) + "px", e.image.$item.css(c)
            }
        }, r.prototype.onScroll = function() {
            var n = this;
            if (n.image.width && n.image.height) {
                var s = t(window).scrollTop(),
                    r = t(window).height(),
                    a = n.$item.offset().top,
                    o = n.$item.outerHeight(!0),
                    l = {
                        visibility: "visible",
                        backgroundPosition: "50% 50%"
                    };
                if (!(s > a + o || a > s + r)) {
                    var u = -(s - a) * n.options.speed;
                    u = n.round(u), e && n.options.enableTransform ? (l.transform = "translateY(" + u + "px)", i && (l.transform = "translate3d(0, " + u + "px, 0)")) : l.backgroundPosition = "50% " + u + "px", n.image.$item.css(l)
                }
            }
        },
        function() {
            t(window).on("scroll.jarallax", function() {
                window.requestAnimationFrame(function() {
                    for (var t = 0, e = s.length; e > t; t++) s[t].onScroll()
                })
            });
            var e;
            t(window).on("resize.jarallax load.jarallax", function() {
                clearTimeout(e), e = setTimeout(function() {
                    window.requestAnimationFrame(function() {
                        for (var t = 0, e = s.length; e > t; t++) {
                            var i = s[t];
                            i.coverImage(), i.clipContainer(), i.onScroll()
                        }
                    })
                }, 100)
            })
        }();
    var a = t.fn.jarallax;
    t.fn.jarallax = function() {
        var t, e = this,
            i = arguments[0],
            n = Array.prototype.slice.call(arguments, 1),
            s = e.length,
            a = 0;
        for (a; s > a; a++)
            if ("object" == typeof i || "undefined" == typeof i ? e[a].jarallax = new r(e[a], i) : t = e[a].jarallax[i].apply(e[a].jarallax, n), "undefined" != typeof t) return t;
        return this
    }, t.fn.jarallax.noConflict = function() {
        return t.fn.jarallax = a, this
    }, t(document).on("ready.data-jarallax", function() {
        t("[data-jarallax]").jarallax()
    })
}), ! function() {
    function t() {
        $.keyboardSupport && p("keydown", r)
    }

    function e() {
        if (!I && document.body) {
            I = !0;
            var e = document.body,
                i = document.documentElement,
                n = window.innerHeight,
                s = e.scrollHeight;
            if (P = document.compatMode.indexOf("CSS") >= 0 ? i : e, F = e, t(), top != self) j = !0;
            else if (s > n && (e.offsetHeight <= n || i.offsetHeight <= n)) {
                var r = document.createElement("div");
                r.style.cssText = "position:absolute; z-index:-10000; top:0; left:0; right:0; height:" + P.scrollHeight + "px", document.body.appendChild(r);
                var a;
                E = function() {
                    a || (a = setTimeout(function() {
                        z || (r.style.height = "0", r.style.height = P.scrollHeight + "px", a = null)
                    }, 500))
                }, setTimeout(E, 10), p("resize", E);
                var o = {
                    attributes: !0,
                    childList: !0,
                    characterData: !1
                };
                if (T = new Y(E), T.observe(e, o), P.offsetHeight <= n) {
                    var l = document.createElement("div");
                    l.style.clear = "both", e.appendChild(l)
                }
            }
            $.fixedBackground || z || (e.style.backgroundAttachment = "scroll", i.style.backgroundAttachment = "scroll")
        }
    }

    function i() {
        T && T.disconnect(), m(X, s), m("mousedown", a), m("keydown", r), m("resize", E), m("load", e)
    }

    function n(t, e, i) {
        if (g(e, i), 1 != $.accelerationMax) {
            var n = Date.now(),
                s = n - H;
            if (s < $.accelerationDelta) {
                var r = (1 + 50 / s) / 2;
                r > 1 && (r = Math.min(r, $.accelerationMax), e *= r, i *= r)
            }
            H = Date.now()
        }
        if (R.push({
                x: e,
                y: i,
                lastX: 0 > e ? .99 : -.99,
                lastY: 0 > i ? .99 : -.99,
                start: Date.now()
            }), !q) {
            var a = t === document.body,
                o = function() {
                    for (var n = Date.now(), s = 0, r = 0, l = 0; l < R.length; l++) {
                        var u = R[l],
                            c = n - u.start,
                            d = c >= $.animationTime,
                            h = d ? 1 : c / $.animationTime;
                        $.pulseAlgorithm && (h = _(h));
                        var p = u.x * h - u.lastX >> 0,
                            m = u.y * h - u.lastY >> 0;
                        s += p, r += m, u.lastX += p, u.lastY += m, d && (R.splice(l, 1), l--)
                    }
                    a ? window.scrollBy(s, r) : (s && (t.scrollLeft += s), r && (t.scrollTop += r)), e || i || (R = []), R.length ? W(o, t, 1e3 / $.frameRate + 1) : q = !1
                };
            W(o, t, 0), q = !0
        }
    }

    function s(t) {
        I || e();
        var i = t.target,
            s = u(i);
        if (!s || t.defaultPrevented || t.ctrlKey) return !0;
        if (f(F, "embed") || f(i, "embed") && /\.pdf/i.test(i.src) || f(F, "object")) return !0;
        var r = -t.wheelDeltaX || t.deltaX || 0,
            a = -t.wheelDeltaY || t.deltaY || 0;
        return L && (t.wheelDeltaX && y(t.wheelDeltaX, 120) && (r = -120 * (t.wheelDeltaX / Math.abs(t.wheelDeltaX))), t.wheelDeltaY && y(t.wheelDeltaY, 120) && (a = -120 * (t.wheelDeltaY / Math.abs(t.wheelDeltaY)))), r || a || (a = -t.wheelDelta || 0), 1 === t.deltaMode && (r *= 40, a *= 40), !$.touchpadSupport && v(a) ? !0 : (Math.abs(r) > 1.2 && (r *= $.stepSize / 120), Math.abs(a) > 1.2 && (a *= $.stepSize / 120), n(s, r, a), t.preventDefault(), void o())
    }

    function r(t) {
        var e = t.target,
            i = t.ctrlKey || t.altKey || t.metaKey || t.shiftKey && t.keyCode !== O.spacebar;
        document.contains(F) || (F = document.activeElement);
        var s = /^(textarea|select|embed|object)$/i,
            r = /^(button|submit|radio|checkbox|file|color|image)$/i;
        if (s.test(e.nodeName) || f(e, "input") && !r.test(e.type) || f(F, "video") || x(t) || e.isContentEditable || t.defaultPrevented || i) return !0;
        if ((f(e, "button") || f(e, "input") && r.test(e.type)) && t.keyCode === O.spacebar) return !0;
        var a, l = 0,
            c = 0,
            d = u(F),
            h = d.clientHeight;
        switch (d == document.body && (h = window.innerHeight), t.keyCode) {
            case O.up:
                c = -$.arrowScroll;
                break;
            case O.down:
                c = $.arrowScroll;
                break;
            case O.spacebar:
                a = t.shiftKey ? 1 : -1, c = -a * h * .9;
                break;
            case O.pageup:
                c = .9 * -h;
                break;
            case O.pagedown:
                c = .9 * h;
                break;
            case O.home:
                c = -d.scrollTop;
                break;
            case O.end:
                var p = d.scrollHeight - d.scrollTop - h;
                c = p > 0 ? p + 10 : 0;
                break;
            case O.left:
                l = -$.arrowScroll;
                break;
            case O.right:
                l = $.arrowScroll;
                break;
            default:
                return !0
        }
        n(d, l, c), t.preventDefault(), o()
    }

    function a(t) {
        F = t.target
    }

    function o() {
        clearTimeout(k), k = setInterval(function() {
            B = {}
        }, 1e3)
    }

    function l(t, e) {
        for (var i = t.length; i--;) B[N(t[i])] = e;
        return e
    }

    function u(t) {
        var e = [],
            i = document.body,
            n = P.scrollHeight;
        do {
            var s = B[N(t)];
            if (s) return l(e, s);
            if (e.push(t), n === t.scrollHeight) {
                var r = d(P) && d(i),
                    a = r || h(P);
                if (j && c(P) || !j && a) return l(e, V())
            } else if (c(t) && h(t)) return l(e, t)
        } while (t = t.parentElement)
    }

    function c(t) {
        return t.clientHeight + 10 < t.scrollHeight
    }

    function d(t) {
        var e = getComputedStyle(t, "").getPropertyValue("overflow-y");
        return "hidden" !== e
    }

    function h(t) {
        var e = getComputedStyle(t, "").getPropertyValue("overflow-y");
        return "scroll" === e || "auto" === e
    }

    function p(t, e) {
        window.addEventListener(t, e, !1)
    }

    function m(t, e) {
        window.removeEventListener(t, e, !1)
    }

    function f(t, e) {
        return (t.nodeName || "").toLowerCase() === e.toLowerCase()
    }

    function g(t, e) {
        t = t > 0 ? 1 : -1, e = e > 0 ? 1 : -1, (M.x !== t || M.y !== e) && (M.x = t, M.y = e, R = [], H = 0)
    }

    function v(t) {
        return t ? (A.length || (A = [t, t, t]), t = Math.abs(t), A.push(t), A.shift(), clearTimeout(S), S = setTimeout(function() {
            window.localStorage && (localStorage.SS_deltaBuffer = A.join(","))
        }, 1e3), !w(120) && !w(100)) : void 0
    }

    function y(t, e) {
        return Math.floor(t / e) == t / e
    }

    function w(t) {
        return y(A[0], t) && y(A[1], t) && y(A[2], t)
    }

    function x(t) {
        var e = t.target,
            i = !1;
        if (-1 != document.URL.indexOf("www.youtube.com/watch"))
            do
                if (i = e.classList && e.classList.contains("html5-video-controls")) break;
        while (e = e.parentNode);
        return i
    }

    function b(t) {
        var e, i, n;
        return t *= $.pulseScale, 1 > t ? e = t - (1 - Math.exp(-t)) : (i = Math.exp(-1), t -= 1, n = 1 - Math.exp(-t), e = i + n * (1 - i)), e * $.pulseNormalize
    }

    function _(t) {
        return t >= 1 ? 1 : 0 >= t ? 0 : (1 == $.pulseNormalize && ($.pulseNormalize /= b(1)), b(t))
    }

    function C(t) {
        for (var e in t) D.hasOwnProperty(e) && ($[e] = t[e])
    }
    var F, T, E, k, S, D = {
            frameRate: 150,
            animationTime: 400,
            stepSize: 100,
            pulseAlgorithm: !0,
            pulseScale: 4,
            pulseNormalize: 1,
            accelerationDelta: 50,
            accelerationMax: 3,
            keyboardSupport: !0,
            arrowScroll: 50,
            touchpadSupport: !1,
            fixedBackground: !0,
            excluded: ""
        },
        $ = D,
        z = !1,
        j = !1,
        M = {
            x: 0,
            y: 0
        },
        I = !1,
        P = document.documentElement,
        A = [],
        L = /^Mac/.test(navigator.platform),
        O = {
            left: 37,
            up: 38,
            right: 39,
            down: 40,
            spacebar: 32,
            pageup: 33,
            pagedown: 34,
            end: 35,
            home: 36
        },
        R = [],
        q = !1,
        H = Date.now(),
        N = function() {
            var t = 0;
            return function(e) {
                return e.uniqueID || (e.uniqueID = t++)
            }
        }(),
        B = {};
    window.localStorage && localStorage.SS_deltaBuffer && (A = localStorage.SS_deltaBuffer.split(","));
    var X, W = function() {
            return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || function(t, e, i) {
                window.setTimeout(t, i || 1e3 / 60)
            }
        }(),
        Y = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver,
        V = function() {
            var t;
            return function() {
                if (!t) {
                    var e = document.createElement("div");
                    e.style.cssText = "height:10000px;width:1px;", document.body.appendChild(e);
                    var i = document.body.scrollTop;
                    document.documentElement.scrollTop, window.scrollBy(0, 1), t = document.body.scrollTop != i ? document.body : document.documentElement, window.scrollBy(0, -1), document.body.removeChild(e)
                }
                return t
            }
        }(),
        Q = window.navigator.userAgent,
        Z = /Edge/.test(Q),
        K = /chrome/i.test(Q) && !Z,
        U = /safari/i.test(Q) && !Z,
        G = /mobile/i.test(Q),
        J = (K || U) && !G;
    "onwheel" in document.createElement("div") ? X = "wheel" : "onmousewheel" in document.createElement("div") && (X = "mousewheel"), X && J && (p(X, s), p("mousedown", a), p("load", e)), C.destroy = i, window.SmoothScrollOptions && C(window.SmoothScrollOptions), "object" == typeof exports ? module.exports = C : window.SmoothScroll = C
}(), ! function(t, e, i, n) {
    function s(e, i) {
        this.settings = null, this.options = t.extend({}, s.Defaults, i), this.$element = t(e), this.drag = t.extend({}, h), this.state = t.extend({}, p), this.e = t.extend({}, m), this._plugins = {}, this._supress = {}, this._current = null, this._speed = null, this._coordinates = [], this._breakpoint = null, this._width = null, this._items = [], this._clones = [], this._mergers = [], this._invalidated = {}, this._pipe = [], t.each(s.Plugins, t.proxy(function(t, e) {
            this._plugins[t[0].toLowerCase() + t.slice(1)] = new e(this)
        }, this)), t.each(s.Pipe, t.proxy(function(e, i) {
            this._pipe.push({
                filter: i.filter,
                run: t.proxy(i.run, this)
            })
        }, this)), this.setup(), this.initialize()
    }

    function r(t) {
        if (t.touches !== n) return {
            x: t.touches[0].pageX,
            y: t.touches[0].pageY
        };
        if (t.touches === n) {
            if (t.pageX !== n) return {
                x: t.pageX,
                y: t.pageY
            };
            if (t.pageX === n) return {
                x: t.clientX,
                y: t.clientY
            }
        }
    }

    function a(t) {
        var e, n, s = i.createElement("div"),
            r = t;
        for (e in r)
            if (n = r[e], "undefined" != typeof s.style[n]) return s = null, [n, e];
        return [!1]
    }

    function o() {
        return a(["transition", "WebkitTransition", "MozTransition", "OTransition"])[1]
    }

    function l() {
        return a(["transform", "WebkitTransform", "MozTransform", "OTransform", "msTransform"])[0]
    }

    function u() {
        return a(["perspective", "webkitPerspective", "MozPerspective", "OPerspective", "MsPerspective"])[0]
    }

    function c() {
        return "ontouchstart" in e || !!navigator.msMaxTouchPoints
    }

    function d() {
        return e.navigator.msPointerEnabled
    }
    var h, p, m;
    h = {
        start: 0,
        startX: 0,
        startY: 0,
        current: 0,
        currentX: 0,
        currentY: 0,
        offsetX: 0,
        offsetY: 0,
        distance: null,
        startTime: 0,
        endTime: 0,
        updatedX: 0,
        targetEl: null
    }, p = {
        isTouch: !1,
        isScrolling: !1,
        isSwiping: !1,
        direction: !1,
        inMotion: !1
    }, m = {
        _onDragStart: null,
        _onDragMove: null,
        _onDragEnd: null,
        _transitionEnd: null,
        _resizer: null,
        _responsiveCall: null,
        _goToLoop: null,
        _checkVisibile: null
    }, s.Defaults = {
        items: 3,
        loop: !1,
        center: !1,
        mouseDrag: !0,
        touchDrag: !0,
        pullDrag: !0,
        freeDrag: !1,
        margin: 0,
        stagePadding: 0,
        merge: !1,
        mergeFit: !0,
        autoWidth: !1,
        startPosition: 0,
        rtl: !1,
        smartSpeed: 250,
        fluidSpeed: !1,
        dragEndSpeed: !1,
        responsive: {},
        responsiveRefreshRate: 200,
        responsiveBaseElement: e,
        responsiveClass: !1,
        fallbackEasing: "swing",
        info: !1,
        nestedItemSelector: !1,
        itemElement: "div",
        stageElement: "div",
        themeClass: "owl-theme",
        baseClass: "owl-carousel",
        itemClass: "owl-item",
        centerClass: "center",
        activeClass: "active"
    }, s.Width = {
        Default: "default",
        Inner: "inner",
        Outer: "outer"
    }, s.Plugins = {}, s.Pipe = [{
        filter: ["width", "items", "settings"],
        run: function(t) {
            t.current = this._items && this._items[this.relative(this._current)]
        }
    }, {
        filter: ["items", "settings"],
        run: function() {
            var t = this._clones,
                e = this.$stage.children(".cloned");
            (e.length !== t.length || !this.settings.loop && t.length > 0) && (this.$stage.children(".cloned").remove(), this._clones = [])
        }
    }, {
        filter: ["items", "settings"],
        run: function() {
            var t, e, i = this._clones,
                n = this._items,
                s = this.settings.loop ? i.length - Math.max(2 * this.settings.items, 4) : 0;
            for (t = 0, e = Math.abs(s / 2); e > t; t++) s > 0 ? (this.$stage.children().eq(n.length + i.length - 1).remove(), i.pop(), this.$stage.children().eq(0).remove(), i.pop()) : (i.push(i.length / 2), this.$stage.append(n[i[i.length - 1]].clone().addClass("cloned")), i.push(n.length - 1 - (i.length - 1) / 2), this.$stage.prepend(n[i[i.length - 1]].clone().addClass("cloned")))
        }
    }, {
        filter: ["width", "items", "settings"],
        run: function() {
            var t, e, i, n = this.settings.rtl ? 1 : -1,
                s = (this.width() / this.settings.items).toFixed(3),
                r = 0;
            for (this._coordinates = [], e = 0, i = this._clones.length + this._items.length; i > e; e++) t = this._mergers[this.relative(e)], t = this.settings.mergeFit && Math.min(t, this.settings.items) || t, r += (this.settings.autoWidth ? this._items[this.relative(e)].width() + this.settings.margin : s * t) * n, this._coordinates.push(r)
        }
    }, {
        filter: ["width", "items", "settings"],
        run: function() {
            var e, i, n = (this.width() / this.settings.items).toFixed(3),
                s = {
                    width: Math.abs(this._coordinates[this._coordinates.length - 1]) + 2 * this.settings.stagePadding,
                    "padding-left": this.settings.stagePadding || "",
                    "padding-right": this.settings.stagePadding || ""
                };
            if (this.$stage.css(s), s = {
                    width: this.settings.autoWidth ? "auto" : n - this.settings.margin
                }, s[this.settings.rtl ? "margin-left" : "margin-right"] = this.settings.margin, !this.settings.autoWidth && t.grep(this._mergers, function(t) {
                    return t > 1
                }).length > 0)
                for (e = 0, i = this._coordinates.length; i > e; e++) s.width = Math.abs(this._coordinates[e]) - Math.abs(this._coordinates[e - 1] || 0) - this.settings.margin, this.$stage.children().eq(e).css(s);
            else this.$stage.children().css(s)
        }
    }, {
        filter: ["width", "items", "settings"],
        run: function(t) {
            t.current && this.reset(this.$stage.children().index(t.current))
        }
    }, {
        filter: ["position"],
        run: function() {
            this.animate(this.coordinates(this._current))
        }
    }, {
        filter: ["width", "position", "items", "settings"],
        run: function() {
            var t, e, i, n, s = this.settings.rtl ? 1 : -1,
                r = 2 * this.settings.stagePadding,
                a = this.coordinates(this.current()) + r,
                o = a + this.width() * s,
                l = [];
            for (i = 0, n = this._coordinates.length; n > i; i++) t = this._coordinates[i - 1] || 0, e = Math.abs(this._coordinates[i]) + r * s, (this.op(t, "<=", a) && this.op(t, ">", o) || this.op(e, "<", a) && this.op(e, ">", o)) && l.push(i);
            this.$stage.children("." + this.settings.activeClass).removeClass(this.settings.activeClass), this.$stage.children(":eq(" + l.join("), :eq(") + ")").addClass(this.settings.activeClass), this.settings.center && (this.$stage.children("." + this.settings.centerClass).removeClass(this.settings.centerClass), this.$stage.children().eq(this.current()).addClass(this.settings.centerClass))
        }
    }], s.prototype.initialize = function() {
        if (this.trigger("initialize"), this.$element.addClass(this.settings.baseClass).addClass(this.settings.themeClass).toggleClass("owl-rtl", this.settings.rtl), this.browserSupport(), this.settings.autoWidth && this.state.imagesLoaded !== !0) {
            var e, i, s;
            if (e = this.$element.find("img"), i = this.settings.nestedItemSelector ? "." + this.settings.nestedItemSelector : n, s = this.$element.children(i).width(), e.length && 0 >= s) return this.preloadAutoWidthImages(e), !1
        }
        this.$element.addClass("owl-loading"), this.$stage = t("<" + this.settings.stageElement + ' class="owl-stage"/>').wrap('<div class="owl-stage-outer">'), this.$element.append(this.$stage.parent()), this.replace(this.$element.children().not(this.$stage.parent())), this._width = this.$element.width(), this.refresh(), this.$element.removeClass("owl-loading").addClass("owl-loaded"), this.eventsCall(), this.internalEvents(), this.addTriggerableEvents(), this.trigger("initialized")
    }, s.prototype.setup = function() {
        var e = this.viewport(),
            i = this.options.responsive,
            n = -1,
            s = null;
        i ? (t.each(i, function(t) {
            e >= t && t > n && (n = Number(t))
        }), s = t.extend({}, this.options, i[n]), delete s.responsive, s.responsiveClass && this.$element.attr("class", function(t, e) {
            return e.replace(/\b owl-responsive-\S+/g, "")
        }).addClass("owl-responsive-" + n)) : s = t.extend({}, this.options), (null === this.settings || this._breakpoint !== n) && (this.trigger("change", {
            property: {
                name: "settings",
                value: s
            }
        }), this._breakpoint = n, this.settings = s, this.invalidate("settings"), this.trigger("changed", {
            property: {
                name: "settings",
                value: this.settings
            }
        }))
    }, s.prototype.optionsLogic = function() {
        this.$element.toggleClass("owl-center", this.settings.center), this.settings.loop && this._items.length < this.settings.items && (this.settings.loop = !1), this.settings.autoWidth && (this.settings.stagePadding = !1, this.settings.merge = !1)
    }, s.prototype.prepare = function(e) {
        var i = this.trigger("prepare", {
            content: e
        });
        return i.data || (i.data = t("<" + this.settings.itemElement + "/>").addClass(this.settings.itemClass).append(e)), this.trigger("prepared", {
            content: i.data
        }), i.data
    }, s.prototype.update = function() {
        for (var e = 0, i = this._pipe.length, n = t.proxy(function(t) {
                return this[t]
            }, this._invalidated), s = {}; i > e;)(this._invalidated.all || t.grep(this._pipe[e].filter, n).length > 0) && this._pipe[e].run(s), e++;
        this._invalidated = {}
    }, s.prototype.width = function(t) {
        switch (t = t || s.Width.Default) {
            case s.Width.Inner:
            case s.Width.Outer:
                return this._width;
            default:
                return this._width - 2 * this.settings.stagePadding + this.settings.margin
        }
    }, s.prototype.refresh = function() {
        return 0 === this._items.length ? !1 : ((new Date).getTime(), this.trigger("refresh"), this.setup(), this.optionsLogic(), this.$stage.addClass("owl-refresh"), this.update(), this.$stage.removeClass("owl-refresh"), this.state.orientation = e.orientation, this.watchVisibility(), void this.trigger("refreshed"))
    }, s.prototype.eventsCall = function() {
        this.e._onDragStart = t.proxy(function(t) {
            this.onDragStart(t)
        }, this), this.e._onDragMove = t.proxy(function(t) {
            this.onDragMove(t)
        }, this), this.e._onDragEnd = t.proxy(function(t) {
            this.onDragEnd(t)
        }, this), this.e._onResize = t.proxy(function(t) {
            this.onResize(t)
        }, this), this.e._transitionEnd = t.proxy(function(t) {
            this.transitionEnd(t)
        }, this), this.e._preventClick = t.proxy(function(t) {
            this.preventClick(t)
        }, this)
    }, s.prototype.onThrottledResize = function() {
        e.clearTimeout(this.resizeTimer), this.resizeTimer = e.setTimeout(this.e._onResize, this.settings.responsiveRefreshRate)
    }, s.prototype.onResize = function() {
        return this._items.length ? this._width === this.$element.width() ? !1 : this.trigger("resize").isDefaultPrevented() ? !1 : (this._width = this.$element.width(), this.invalidate("width"), this.refresh(), void this.trigger("resized")) : !1
    }, s.prototype.eventsRouter = function(t) {
        var e = t.type;
        "mousedown" === e || "touchstart" === e ? this.onDragStart(t) : "mousemove" === e || "touchmove" === e ? this.onDragMove(t) : "mouseup" === e || "touchend" === e ? this.onDragEnd(t) : "touchcancel" === e && this.onDragEnd(t)
    }, s.prototype.internalEvents = function() {
        var i = (c(), d());
        this.settings.mouseDrag ? (this.$stage.on("mousedown", t.proxy(function(t) {
            this.eventsRouter(t)
        }, this)), this.$stage.on("dragstart", function() {
            return !1
        }), this.$stage.get(0).onselectstart = function() {
            return !1
        }) : this.$element.addClass("owl-text-select-on"), this.settings.touchDrag && !i && this.$stage.on("touchstart touchcancel", t.proxy(function(t) {
            this.eventsRouter(t)
        }, this)), this.transitionEndVendor && this.on(this.$stage.get(0), this.transitionEndVendor, this.e._transitionEnd, !1), this.settings.responsive !== !1 && this.on(e, "resize", t.proxy(this.onThrottledResize, this))
    }, s.prototype.onDragStart = function(n) {
        var s, a, o, l;
        if (s = n.originalEvent || n || e.event, 3 === s.which || this.state.isTouch) return !1;
        if ("mousedown" === s.type && this.$stage.addClass("owl-grab"), this.trigger("drag"), this.drag.startTime = (new Date).getTime(), this.speed(0), this.state.isTouch = !0, this.state.isScrolling = !1, this.state.isSwiping = !1, this.drag.distance = 0, a = r(s).x, o = r(s).y, this.drag.offsetX = this.$stage.position().left, this.drag.offsetY = this.$stage.position().top, this.settings.rtl && (this.drag.offsetX = this.$stage.position().left + this.$stage.width() - this.width() + this.settings.margin), this.state.inMotion && this.support3d) l = this.getTransformProperty(), this.drag.offsetX = l, this.animate(l), this.state.inMotion = !0;
        else if (this.state.inMotion && !this.support3d) return this.state.inMotion = !1, !1;
        this.drag.startX = a - this.drag.offsetX, this.drag.startY = o - this.drag.offsetY, this.drag.start = a - this.drag.startX, this.drag.targetEl = s.target || s.srcElement, this.drag.updatedX = this.drag.start, ("IMG" === this.drag.targetEl.tagName || "A" === this.drag.targetEl.tagName) && (this.drag.targetEl.draggable = !1), t(i).on("mousemove.owl.dragEvents mouseup.owl.dragEvents touchmove.owl.dragEvents touchend.owl.dragEvents", t.proxy(function(t) {
            this.eventsRouter(t)
        }, this))
    }, s.prototype.onDragMove = function(t) {
        var i, s, a, o, l, u;
        this.state.isTouch && (this.state.isScrolling || (i = t.originalEvent || t || e.event, s = r(i).x, a = r(i).y, this.drag.currentX = s - this.drag.startX, this.drag.currentY = a - this.drag.startY, this.drag.distance = this.drag.currentX - this.drag.offsetX, this.drag.distance < 0 ? this.state.direction = this.settings.rtl ? "right" : "left" : this.drag.distance > 0 && (this.state.direction = this.settings.rtl ? "left" : "right"), this.settings.loop ? this.op(this.drag.currentX, ">", this.coordinates(this.minimum())) && "right" === this.state.direction ? this.drag.currentX -= (this.settings.center && this.coordinates(0)) - this.coordinates(this._items.length) : this.op(this.drag.currentX, "<", this.coordinates(this.maximum())) && "left" === this.state.direction && (this.drag.currentX += (this.settings.center && this.coordinates(0)) - this.coordinates(this._items.length)) : (o = this.coordinates(this.settings.rtl ? this.maximum() : this.minimum()), l = this.coordinates(this.settings.rtl ? this.minimum() : this.maximum()), u = this.settings.pullDrag ? this.drag.distance / 5 : 0, this.drag.currentX = Math.max(Math.min(this.drag.currentX, o + u), l + u)), (this.drag.distance > 8 || this.drag.distance < -8) && (i.preventDefault !== n ? i.preventDefault() : i.returnValue = !1, this.state.isSwiping = !0), this.drag.updatedX = this.drag.currentX, (this.drag.currentY > 16 || this.drag.currentY < -16) && this.state.isSwiping === !1 && (this.state.isScrolling = !0, this.drag.updatedX = this.drag.start), this.animate(this.drag.updatedX)))
    }, s.prototype.onDragEnd = function(e) {
        var n, s, r;
        if (this.state.isTouch) {
            if ("mouseup" === e.type && this.$stage.removeClass("owl-grab"), this.trigger("dragged"), this.drag.targetEl.removeAttribute("draggable"), this.state.isTouch = !1, this.state.isScrolling = !1, this.state.isSwiping = !1, 0 === this.drag.distance && this.state.inMotion !== !0) return this.state.inMotion = !1, !1;
            this.drag.endTime = (new Date).getTime(), n = this.drag.endTime - this.drag.startTime, s = Math.abs(this.drag.distance), (s > 3 || n > 300) && this.removeClick(this.drag.targetEl), r = this.closest(this.drag.updatedX), this.speed(this.settings.dragEndSpeed || this.settings.smartSpeed), this.current(r), this.invalidate("position"), this.update(), this.settings.pullDrag || this.drag.updatedX !== this.coordinates(r) || this.transitionEnd(), this.drag.distance = 0, t(i).off(".owl.dragEvents")
        }
    }, s.prototype.removeClick = function(i) {
        this.drag.targetEl = i, t(i).on("click.preventClick", this.e._preventClick), e.setTimeout(function() {
            t(i).off("click.preventClick")
        }, 300)
    }, s.prototype.preventClick = function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = !1, e.stopPropagation && e.stopPropagation(), t(e.target).off("click.preventClick")
    }, s.prototype.getTransformProperty = function() {
        var t, i;
        return t = e.getComputedStyle(this.$stage.get(0), null).getPropertyValue(this.vendorName + "transform"), t = t.replace(/matrix(3d)?\(|\)/g, "").split(","), i = 16 === t.length, i !== !0 ? t[4] : t[12]
    }, s.prototype.closest = function(e) {
        var i = -1,
            n = 30,
            s = this.width(),
            r = this.coordinates();
        return this.settings.freeDrag || t.each(r, t.proxy(function(t, a) {
            return e > a - n && a + n > e ? i = t : this.op(e, "<", a) && this.op(e, ">", r[t + 1] || a - s) && (i = "left" === this.state.direction ? t + 1 : t), -1 === i
        }, this)), this.settings.loop || (this.op(e, ">", r[this.minimum()]) ? i = e = this.minimum() : this.op(e, "<", r[this.maximum()]) && (i = e = this.maximum())), i
    }, s.prototype.animate = function(e) {
        this.trigger("translate"), this.state.inMotion = this.speed() > 0, this.support3d ? this.$stage.css({
            transform: "translate3d(" + e + "px,0px, 0px)",
            transition: this.speed() / 1e3 + "s"
        }) : this.state.isTouch ? this.$stage.css({
            left: e + "px"
        }) : this.$stage.animate({
            left: e
        }, this.speed() / 1e3, this.settings.fallbackEasing, t.proxy(function() {
            this.state.inMotion && this.transitionEnd()
        }, this))
    }, s.prototype.current = function(t) {
        if (t === n) return this._current;
        if (0 === this._items.length) return n;
        if (t = this.normalize(t), this._current !== t) {
            var e = this.trigger("change", {
                property: {
                    name: "position",
                    value: t
                }
            });
            e.data !== n && (t = this.normalize(e.data)), this._current = t, this.invalidate("position"), this.trigger("changed", {
                property: {
                    name: "position",
                    value: this._current
                }
            })
        }
        return this._current
    }, s.prototype.invalidate = function(t) {
        this._invalidated[t] = !0
    }, s.prototype.reset = function(t) {
        t = this.normalize(t), t !== n && (this._speed = 0, this._current = t, this.suppress(["translate", "translated"]), this.animate(this.coordinates(t)), this.release(["translate", "translated"]))
    }, s.prototype.normalize = function(e, i) {
        var s = i ? this._items.length : this._items.length + this._clones.length;
        return !t.isNumeric(e) || 1 > s ? n : e = this._clones.length ? (e % s + s) % s : Math.max(this.minimum(i), Math.min(this.maximum(i), e))
    }, s.prototype.relative = function(t) {
        return t = this.normalize(t), t -= this._clones.length / 2, this.normalize(t, !0)
    }, s.prototype.maximum = function(t) {
        var e, i, n, s = 0,
            r = this.settings;
        if (t) return this._items.length - 1;
        if (!r.loop && r.center) e = this._items.length - 1;
        else if (r.loop || r.center)
            if (r.loop || r.center) e = this._items.length + r.items;
            else {
                if (!r.autoWidth && !r.merge) throw "Can not detect maximum absolute position.";
                for (revert = r.rtl ? 1 : -1, i = this.$stage.width() - this.$element.width();
                    (n = this.coordinates(s)) && !(n * revert >= i);) e = ++s
            }
        else e = this._items.length - r.items;
        return e
    }, s.prototype.minimum = function(t) {
        return t ? 0 : this._clones.length / 2
    }, s.prototype.items = function(t) {
        return t === n ? this._items.slice() : (t = this.normalize(t, !0), this._items[t])
    }, s.prototype.mergers = function(t) {
        return t === n ? this._mergers.slice() : (t = this.normalize(t, !0), this._mergers[t])
    }, s.prototype.clones = function(e) {
        var i = this._clones.length / 2,
            s = i + this._items.length,
            r = function(t) {
                return t % 2 === 0 ? s + t / 2 : i - (t + 1) / 2
            };
        return e === n ? t.map(this._clones, function(t, e) {
            return r(e)
        }) : t.map(this._clones, function(t, i) {
            return t === e ? r(i) : null
        })
    }, s.prototype.speed = function(t) {
        return t !== n && (this._speed = t), this._speed
    }, s.prototype.coordinates = function(e) {
        var i = null;
        return e === n ? t.map(this._coordinates, t.proxy(function(t, e) {
            return this.coordinates(e)
        }, this)) : (this.settings.center ? (i = this._coordinates[e], i += (this.width() - i + (this._coordinates[e - 1] || 0)) / 2 * (this.settings.rtl ? -1 : 1)) : i = this._coordinates[e - 1] || 0, i)
    }, s.prototype.duration = function(t, e, i) {
        return Math.min(Math.max(Math.abs(e - t), 1), 6) * Math.abs(i || this.settings.smartSpeed)
    }, s.prototype.to = function(i, n) {
        if (this.settings.loop) {
            var s = i - this.relative(this.current()),
                r = this.current(),
                a = this.current(),
                o = this.current() + s,
                l = 0 > a - o ? !0 : !1,
                u = this._clones.length + this._items.length;
            o < this.settings.items && l === !1 ? (r = a + this._items.length, this.reset(r)) : o >= u - this.settings.items && l === !0 && (r = a - this._items.length, this.reset(r)), e.clearTimeout(this.e._goToLoop), this.e._goToLoop = e.setTimeout(t.proxy(function() {
                this.speed(this.duration(this.current(), r + s, n)), this.current(r + s), this.update()
            }, this), 30)
        } else this.speed(this.duration(this.current(), i, n)), this.current(i), this.update()
    }, s.prototype.next = function(t) {
        t = t || !1, this.to(this.relative(this.current()) + 1, t)
    }, s.prototype.prev = function(t) {
        t = t || !1, this.to(this.relative(this.current()) - 1, t)
    }, s.prototype.transitionEnd = function(t) {
        return t !== n && (t.stopPropagation(), (t.target || t.srcElement || t.originalTarget) !== this.$stage.get(0)) ? !1 : (this.state.inMotion = !1, void this.trigger("translated"))
    }, s.prototype.viewport = function() {
        var n;
        if (this.options.responsiveBaseElement !== e) n = t(this.options.responsiveBaseElement).width();
        else if (e.innerWidth) n = e.innerWidth;
        else {
            if (!i.documentElement || !i.documentElement.clientWidth) throw "Can not detect viewport width.";
            n = i.documentElement.clientWidth
        }
        return n
    }, s.prototype.replace = function(e) {
        this.$stage.empty(), this._items = [], e && (e = e instanceof jQuery ? e : t(e)), this.settings.nestedItemSelector && (e = e.find("." + this.settings.nestedItemSelector)), e.filter(function() {
                return 1 === this.nodeType
            }).each(t.proxy(function(t, e) {
                e = this.prepare(e), this.$stage.append(e), this._items.push(e), this._mergers.push(1 * e.find("[data-merge]").andSelf("[data-merge]").attr("data-merge") || 1)
            }, this)), this.reset(t.isNumeric(this.settings.startPosition) ? this.settings.startPosition : 0),
            this.invalidate("items")
    }, s.prototype.add = function(t, e) {
        e = e === n ? this._items.length : this.normalize(e, !0), this.trigger("add", {
            content: t,
            position: e
        }), 0 === this._items.length || e === this._items.length ? (this.$stage.append(t), this._items.push(t), this._mergers.push(1 * t.find("[data-merge]").andSelf("[data-merge]").attr("data-merge") || 1)) : (this._items[e].before(t), this._items.splice(e, 0, t), this._mergers.splice(e, 0, 1 * t.find("[data-merge]").andSelf("[data-merge]").attr("data-merge") || 1)), this.invalidate("items"), this.trigger("added", {
            content: t,
            position: e
        })
    }, s.prototype.remove = function(t) {
        t = this.normalize(t, !0), t !== n && (this.trigger("remove", {
            content: this._items[t],
            position: t
        }), this._items[t].remove(), this._items.splice(t, 1), this._mergers.splice(t, 1), this.invalidate("items"), this.trigger("removed", {
            content: null,
            position: t
        }))
    }, s.prototype.addTriggerableEvents = function() {
        var e = t.proxy(function(e, i) {
            return t.proxy(function(t) {
                t.relatedTarget !== this && (this.suppress([i]), e.apply(this, [].slice.call(arguments, 1)), this.release([i]))
            }, this)
        }, this);
        t.each({
            next: this.next,
            prev: this.prev,
            to: this.to,
            destroy: this.destroy,
            refresh: this.refresh,
            replace: this.replace,
            add: this.add,
            remove: this.remove
        }, t.proxy(function(t, i) {
            this.$element.on(t + ".owl.carousel", e(i, t + ".owl.carousel"))
        }, this))
    }, s.prototype.watchVisibility = function() {
        function i(t) {
            return t.offsetWidth > 0 && t.offsetHeight > 0
        }

        function n() {
            i(this.$element.get(0)) && (this.$element.removeClass("owl-hidden"), this.refresh(), e.clearInterval(this.e._checkVisibile))
        }
        i(this.$element.get(0)) || (this.$element.addClass("owl-hidden"), e.clearInterval(this.e._checkVisibile), this.e._checkVisibile = e.setInterval(t.proxy(n, this), 500))
    }, s.prototype.preloadAutoWidthImages = function(e) {
        var i, n, s, r;
        i = 0, n = this, e.each(function(a, o) {
            s = t(o), r = new Image, r.onload = function() {
                i++, s.attr("src", r.src), s.css("opacity", 1), i >= e.length && (n.state.imagesLoaded = !0, n.initialize())
            }, r.src = s.attr("src") || s.attr("data-src") || s.attr("data-src-retina")
        })
    }, s.prototype.destroy = function() {
        this.$element.hasClass(this.settings.themeClass) && this.$element.removeClass(this.settings.themeClass), this.settings.responsive !== !1 && t(e).off("resize.owl.carousel"), this.transitionEndVendor && this.off(this.$stage.get(0), this.transitionEndVendor, this.e._transitionEnd);
        for (var n in this._plugins) this._plugins[n].destroy();
        (this.settings.mouseDrag || this.settings.touchDrag) && (this.$stage.off("mousedown touchstart touchcancel"), t(i).off(".owl.dragEvents"), this.$stage.get(0).onselectstart = function() {}, this.$stage.off("dragstart", function() {
            return !1
        })), this.$element.off(".owl"), this.$stage.children(".cloned").remove(), this.e = null, this.$element.removeData("owlCarousel"), this.$stage.children().contents().unwrap(), this.$stage.children().unwrap(), this.$stage.unwrap()
    }, s.prototype.op = function(t, e, i) {
        var n = this.settings.rtl;
        switch (e) {
            case "<":
                return n ? t > i : i > t;
            case ">":
                return n ? i > t : t > i;
            case ">=":
                return n ? i >= t : t >= i;
            case "<=":
                return n ? t >= i : i >= t
        }
    }, s.prototype.on = function(t, e, i, n) {
        t.addEventListener ? t.addEventListener(e, i, n) : t.attachEvent && t.attachEvent("on" + e, i)
    }, s.prototype.off = function(t, e, i, n) {
        t.removeEventListener ? t.removeEventListener(e, i, n) : t.detachEvent && t.detachEvent("on" + e, i)
    }, s.prototype.trigger = function(e, i, n) {
        var s = {
                item: {
                    count: this._items.length,
                    index: this.current()
                }
            },
            r = t.camelCase(t.grep(["on", e, n], function(t) {
                return t
            }).join("-").toLowerCase()),
            a = t.Event([e, "owl", n || "carousel"].join(".").toLowerCase(), t.extend({
                relatedTarget: this
            }, s, i));
        return this._supress[e] || (t.each(this._plugins, function(t, e) {
            e.onTrigger && e.onTrigger(a)
        }), this.$element.trigger(a), this.settings && "function" == typeof this.settings[r] && this.settings[r].apply(this, a)), a
    }, s.prototype.suppress = function(e) {
        t.each(e, t.proxy(function(t, e) {
            this._supress[e] = !0
        }, this))
    }, s.prototype.release = function(e) {
        t.each(e, t.proxy(function(t, e) {
            delete this._supress[e]
        }, this))
    }, s.prototype.browserSupport = function() {
        if (this.support3d = u(), this.support3d) {
            this.transformVendor = l();
            var t = ["transitionend", "webkitTransitionEnd", "transitionend", "oTransitionEnd"];
            this.transitionEndVendor = t[o()], this.vendorName = this.transformVendor.replace(/Transform/i, ""), this.vendorName = "" !== this.vendorName ? "-" + this.vendorName.toLowerCase() + "-" : ""
        }
        this.state.orientation = e.orientation
    }, t.fn.owlCarousel = function(e) {
        return this.each(function() {
            t(this).data("owlCarousel") || t(this).data("owlCarousel", new s(this, e))
        })
    }, t.fn.owlCarousel.Constructor = s
}(window.Zepto || window.jQuery, window, document),
function(t, e) {
    var i = function(e) {
        this._core = e, this._loaded = [], this._handlers = {
            "initialized.owl.carousel change.owl.carousel": t.proxy(function(e) {
                if (e.namespace && this._core.settings && this._core.settings.lazyLoad && (e.property && "position" == e.property.name || "initialized" == e.type))
                    for (var i = this._core.settings, n = i.center && Math.ceil(i.items / 2) || i.items, s = i.center && -1 * n || 0, r = (e.property && e.property.value || this._core.current()) + s, a = this._core.clones().length, o = t.proxy(function(t, e) {
                            this.load(e)
                        }, this); s++ < n;) this.load(a / 2 + this._core.relative(r)), a && t.each(this._core.clones(this._core.relative(r++)), o)
            }, this)
        }, this._core.options = t.extend({}, i.Defaults, this._core.options), this._core.$element.on(this._handlers)
    };
    i.Defaults = {
        lazyLoad: !1
    }, i.prototype.load = function(i) {
        var n = this._core.$stage.children().eq(i),
            s = n && n.find(".owl-lazy");
        !s || t.inArray(n.get(0), this._loaded) > -1 || (s.each(t.proxy(function(i, n) {
            var s, r = t(n),
                a = e.devicePixelRatio > 1 && r.attr("data-src-retina") || r.attr("data-src");
            this._core.trigger("load", {
                element: r,
                url: a
            }, "lazy"), r.is("img") ? r.one("load.owl.lazy", t.proxy(function() {
                r.css("opacity", 1), this._core.trigger("loaded", {
                    element: r,
                    url: a
                }, "lazy")
            }, this)).attr("src", a) : (s = new Image, s.onload = t.proxy(function() {
                r.css({
                    "background-image": "url(" + a + ")",
                    opacity: "1"
                }), this._core.trigger("loaded", {
                    element: r,
                    url: a
                }, "lazy")
            }, this), s.src = a)
        }, this)), this._loaded.push(n.get(0)))
    }, i.prototype.destroy = function() {
        var t, e;
        for (t in this.handlers) this._core.$element.off(t, this.handlers[t]);
        for (e in Object.getOwnPropertyNames(this)) "function" != typeof this[e] && (this[e] = null)
    }, t.fn.owlCarousel.Constructor.Plugins.Lazy = i
}(window.Zepto || window.jQuery, window, document),
function(t) {
    var e = function(i) {
        this._core = i, this._handlers = {
            "initialized.owl.carousel": t.proxy(function() {
                this._core.settings.autoHeight && this.update()
            }, this),
            "changed.owl.carousel": t.proxy(function(t) {
                this._core.settings.autoHeight && "position" == t.property.name && this.update()
            }, this),
            "loaded.owl.lazy": t.proxy(function(t) {
                this._core.settings.autoHeight && t.element.closest("." + this._core.settings.itemClass) === this._core.$stage.children().eq(this._core.current()) && this.update()
            }, this)
        }, this._core.options = t.extend({}, e.Defaults, this._core.options), this._core.$element.on(this._handlers)
    };
    e.Defaults = {
        autoHeight: !1,
        autoHeightClass: "owl-height"
    }, e.prototype.update = function() {
        this._core.$stage.parent().height(this._core.$stage.children().eq(this._core.current()).height()).addClass(this._core.settings.autoHeightClass)
    }, e.prototype.destroy = function() {
        var t, e;
        for (t in this._handlers) this._core.$element.off(t, this._handlers[t]);
        for (e in Object.getOwnPropertyNames(this)) "function" != typeof this[e] && (this[e] = null)
    }, t.fn.owlCarousel.Constructor.Plugins.AutoHeight = e
}(window.Zepto || window.jQuery, window, document),
function(t, e, i) {
    var n = function(e) {
        this._core = e, this._videos = {}, this._playing = null, this._fullscreen = !1, this._handlers = {
            "resize.owl.carousel": t.proxy(function(t) {
                this._core.settings.video && !this.isInFullScreen() && t.preventDefault()
            }, this),
            "refresh.owl.carousel changed.owl.carousel": t.proxy(function() {
                this._playing && this.stop()
            }, this),
            "prepared.owl.carousel": t.proxy(function(e) {
                var i = t(e.content).find(".owl-video");
                i.length && (i.css("display", "none"), this.fetch(i, t(e.content)))
            }, this)
        }, this._core.options = t.extend({}, n.Defaults, this._core.options), this._core.$element.on(this._handlers), this._core.$element.on("click.owl.video", ".owl-video-play-icon", t.proxy(function(t) {
            this.play(t)
        }, this))
    };
    n.Defaults = {
        video: !1,
        videoHeight: !1,
        videoWidth: !1
    }, n.prototype.fetch = function(t, e) {
        var i = t.attr("data-vimeo-id") ? "vimeo" : "youtube",
            n = t.attr("data-vimeo-id") || t.attr("data-youtube-id"),
            s = t.attr("data-width") || this._core.settings.videoWidth,
            r = t.attr("data-height") || this._core.settings.videoHeight,
            a = t.attr("href");
        if (!a) throw new Error("Missing video URL.");
        if (n = a.match(/(http:|https:|)\/\/(player.|www.)?(vimeo\.com|youtu(be\.com|\.be|be\.googleapis\.com))\/(video\/|embed\/|watch\?v=|v\/)?([A-Za-z0-9._%-]*)(\&\S+)?/), n[3].indexOf("youtu") > -1) i = "youtube";
        else {
            if (!(n[3].indexOf("vimeo") > -1)) throw new Error("Video URL not supported.");
            i = "vimeo"
        }
        n = n[6], this._videos[a] = {
            type: i,
            id: n,
            width: s,
            height: r
        }, e.attr("data-video", a), this.thumbnail(t, this._videos[a])
    }, n.prototype.thumbnail = function(e, i) {
        var n, s, r, a = i.width && i.height ? 'style="width:' + i.width + "px;height:" + i.height + 'px;"' : "",
            o = e.find("img"),
            l = "src",
            u = "",
            c = this._core.settings,
            d = function(t) {
                s = '<div class="owl-video-play-icon"></div>', n = c.lazyLoad ? '<div class="owl-video-tn ' + u + '" ' + l + '="' + t + '"></div>' : '<div class="owl-video-tn" style="opacity:1;background-image:url(' + t + ')"></div>', e.after(n), e.after(s)
            };
        return e.wrap('<div class="owl-video-wrapper"' + a + "></div>"), this._core.settings.lazyLoad && (l = "data-src", u = "owl-lazy"), o.length ? (d(o.attr(l)), o.remove(), !1) : void("youtube" === i.type ? (r = "http://img.youtube.com/vi/" + i.id + "/hqdefault.jpg", d(r)) : "vimeo" === i.type && t.ajax({
            type: "GET",
            url: "http://vimeo.com/api/v2/video/" + i.id + ".json",
            jsonp: "callback",
            dataType: "jsonp",
            success: function(t) {
                r = t[0].thumbnail_large, d(r)
            }
        }))
    }, n.prototype.stop = function() {
        this._core.trigger("stop", null, "video"), this._playing.find(".owl-video-frame").remove(), this._playing.removeClass("owl-video-playing"), this._playing = null
    }, n.prototype.play = function(e) {
        this._core.trigger("play", null, "video"), this._playing && this.stop();
        var i, n, s = t(e.target || e.srcElement),
            r = s.closest("." + this._core.settings.itemClass),
            a = this._videos[r.attr("data-video")],
            o = a.width || "100%",
            l = a.height || this._core.$stage.height();
        "youtube" === a.type ? i = '<iframe width="' + o + '" height="' + l + '" src="http://www.youtube.com/embed/' + a.id + "?autoplay=1&v=" + a.id + '" frameborder="0" allowfullscreen></iframe>' : "vimeo" === a.type && (i = '<iframe src="http://player.vimeo.com/video/' + a.id + '?autoplay=1" width="' + o + '" height="' + l + '" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>'), r.addClass("owl-video-playing"), this._playing = r, n = t('<div style="height:' + l + "px; width:" + o + 'px" class="owl-video-frame">' + i + "</div>"), s.after(n)
    }, n.prototype.isInFullScreen = function() {
        var n = i.fullscreenElement || i.mozFullScreenElement || i.webkitFullscreenElement;
        return n && t(n).parent().hasClass("owl-video-frame") && (this._core.speed(0), this._fullscreen = !0), n && this._fullscreen && this._playing ? !1 : this._fullscreen ? (this._fullscreen = !1, !1) : this._playing && this._core.state.orientation !== e.orientation ? (this._core.state.orientation = e.orientation, !1) : !0
    }, n.prototype.destroy = function() {
        var t, e;
        this._core.$element.off("click.owl.video");
        for (t in this._handlers) this._core.$element.off(t, this._handlers[t]);
        for (e in Object.getOwnPropertyNames(this)) "function" != typeof this[e] && (this[e] = null)
    }, t.fn.owlCarousel.Constructor.Plugins.Video = n
}(window.Zepto || window.jQuery, window, document),
function(t, e, i, n) {
    var s = function(e) {
        this.core = e, this.core.options = t.extend({}, s.Defaults, this.core.options), this.swapping = !0, this.previous = n, this.next = n, this.handlers = {
            "change.owl.carousel": t.proxy(function(t) {
                "position" == t.property.name && (this.previous = this.core.current(), this.next = t.property.value)
            }, this),
            "drag.owl.carousel dragged.owl.carousel translated.owl.carousel": t.proxy(function(t) {
                this.swapping = "translated" == t.type
            }, this),
            "translate.owl.carousel": t.proxy(function() {
                this.swapping && (this.core.options.animateOut || this.core.options.animateIn) && this.swap()
            }, this)
        }, this.core.$element.on(this.handlers)
    };
    s.Defaults = {
        animateOut: !1,
        animateIn: !1
    }, s.prototype.swap = function() {
        if (1 === this.core.settings.items && this.core.support3d) {
            this.core.speed(0);
            var e, i = t.proxy(this.clear, this),
                n = this.core.$stage.children().eq(this.previous),
                s = this.core.$stage.children().eq(this.next),
                r = this.core.settings.animateIn,
                a = this.core.settings.animateOut;
            this.core.current() !== this.previous && (a && (e = this.core.coordinates(this.previous) - this.core.coordinates(this.next), n.css({
                left: e + "px"
            }).addClass("animated owl-animated-out").addClass(a).one("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", i)), r && s.addClass("animated owl-animated-in").addClass(r).one("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", i))
        }
    }, s.prototype.clear = function(e) {
        t(e.target).css({
            left: ""
        }).removeClass("animated owl-animated-out owl-animated-in").removeClass(this.core.settings.animateIn).removeClass(this.core.settings.animateOut), this.core.transitionEnd()
    }, s.prototype.destroy = function() {
        var t, e;
        for (t in this.handlers) this.core.$element.off(t, this.handlers[t]);
        for (e in Object.getOwnPropertyNames(this)) "function" != typeof this[e] && (this[e] = null)
    }, t.fn.owlCarousel.Constructor.Plugins.Animate = s
}(window.Zepto || window.jQuery, window, document),
function(t, e, i) {
    var n = function(e) {
        this.core = e, this.core.options = t.extend({}, n.Defaults, this.core.options), this.handlers = {
            "translated.owl.carousel refreshed.owl.carousel": t.proxy(function() {
                this.autoplay()
            }, this),
            "play.owl.autoplay": t.proxy(function(t, e, i) {
                this.play(e, i)
            }, this),
            "stop.owl.autoplay": t.proxy(function() {
                this.stop()
            }, this),
            "mouseover.owl.autoplay": t.proxy(function() {
                this.core.settings.autoplayHoverPause && this.pause()
            }, this),
            "mouseleave.owl.autoplay": t.proxy(function() {
                this.core.settings.autoplayHoverPause && this.autoplay()
            }, this)
        }, this.core.$element.on(this.handlers)
    };
    n.Defaults = {
        autoplay: !1,
        autoplayTimeout: 5e3,
        autoplayHoverPause: !1,
        autoplaySpeed: !1
    }, n.prototype.autoplay = function() {
        this.core.settings.autoplay && !this.core.state.videoPlay ? (e.clearInterval(this.interval), this.interval = e.setInterval(t.proxy(function() {
            this.play()
        }, this), this.core.settings.autoplayTimeout)) : e.clearInterval(this.interval)
    }, n.prototype.play = function() {
        return i.hidden === !0 || this.core.state.isTouch || this.core.state.isScrolling || this.core.state.isSwiping || this.core.state.inMotion ? void 0 : this.core.settings.autoplay === !1 ? void e.clearInterval(this.interval) : void this.core.next(this.core.settings.autoplaySpeed)
    }, n.prototype.stop = function() {
        e.clearInterval(this.interval)
    }, n.prototype.pause = function() {
        e.clearInterval(this.interval)
    }, n.prototype.destroy = function() {
        var t, i;
        e.clearInterval(this.interval);
        for (t in this.handlers) this.core.$element.off(t, this.handlers[t]);
        for (i in Object.getOwnPropertyNames(this)) "function" != typeof this[i] && (this[i] = null)
    }, t.fn.owlCarousel.Constructor.Plugins.autoplay = n
}(window.Zepto || window.jQuery, window, document),
function(t) {
    "use strict";
    var e = function(i) {
        this._core = i, this._initialized = !1, this._pages = [], this._controls = {}, this._templates = [], this.$element = this._core.$element, this._overrides = {
            next: this._core.next,
            prev: this._core.prev,
            to: this._core.to
        }, this._handlers = {
            "prepared.owl.carousel": t.proxy(function(e) {
                this._core.settings.dotsData && this._templates.push(t(e.content).find("[data-dot]").andSelf("[data-dot]").attr("data-dot"))
            }, this),
            "add.owl.carousel": t.proxy(function(e) {
                this._core.settings.dotsData && this._templates.splice(e.position, 0, t(e.content).find("[data-dot]").andSelf("[data-dot]").attr("data-dot"))
            }, this),
            "remove.owl.carousel prepared.owl.carousel": t.proxy(function(t) {
                this._core.settings.dotsData && this._templates.splice(t.position, 1)
            }, this),
            "change.owl.carousel": t.proxy(function(t) {
                if ("position" == t.property.name && !this._core.state.revert && !this._core.settings.loop && this._core.settings.navRewind) {
                    var e = this._core.current(),
                        i = this._core.maximum(),
                        n = this._core.minimum();
                    t.data = t.property.value > i ? e >= i ? n : i : t.property.value < n ? i : t.property.value
                }
            }, this),
            "changed.owl.carousel": t.proxy(function(t) {
                "position" == t.property.name && this.draw()
            }, this),
            "refreshed.owl.carousel": t.proxy(function() {
                this._initialized || (this.initialize(), this._initialized = !0), this._core.trigger("refresh", null, "navigation"), this.update(), this.draw(), this._core.trigger("refreshed", null, "navigation")
            }, this)
        }, this._core.options = t.extend({}, e.Defaults, this._core.options), this.$element.on(this._handlers)
    };
    e.Defaults = {
        nav: !1,
        navRewind: !0,
        navText: ["prev", "next"],
        navSpeed: !1,
        navElement: "div",
        navContainer: !1,
        navContainerClass: "owl-nav",
        navClass: ["owl-prev", "owl-next"],
        slideBy: 1,
        dotClass: "owl-dot",
        dotsClass: "owl-dots",
        dots: !0,
        dotsEach: !1,
        dotData: !1,
        dotsSpeed: !1,
        dotsContainer: !1,
        controlsClass: "owl-controls"
    }, e.prototype.initialize = function() {
        var e, i, n = this._core.settings;
        n.dotsData || (this._templates = [t("<div>").addClass(n.dotClass).append(t("<span>")).prop("outerHTML")]), n.navContainer && n.dotsContainer || (this._controls.$container = t("<div>").addClass(n.controlsClass).appendTo(this.$element)), this._controls.$indicators = n.dotsContainer ? t(n.dotsContainer) : t("<div>").hide().addClass(n.dotsClass).appendTo(this._controls.$container), this._controls.$indicators.on("click", "div", t.proxy(function(e) {
            var i = t(e.target).parent().is(this._controls.$indicators) ? t(e.target).index() : t(e.target).parent().index();
            e.preventDefault(), this.to(i, n.dotsSpeed)
        }, this)), e = n.navContainer ? t(n.navContainer) : t("<div>").addClass(n.navContainerClass).prependTo(this._controls.$container), this._controls.$next = t("<" + n.navElement + ">"), this._controls.$previous = this._controls.$next.clone(), this._controls.$previous.addClass(n.navClass[0]).html(n.navText[0]).hide().prependTo(e).on("click", t.proxy(function() {
            this.prev(n.navSpeed)
        }, this)), this._controls.$next.addClass(n.navClass[1]).html(n.navText[1]).hide().appendTo(e).on("click", t.proxy(function() {
            this.next(n.navSpeed)
        }, this));
        for (i in this._overrides) this._core[i] = t.proxy(this[i], this)
    }, e.prototype.destroy = function() {
        var t, e, i, n;
        for (t in this._handlers) this.$element.off(t, this._handlers[t]);
        for (e in this._controls) this._controls[e].remove();
        for (n in this.overides) this._core[n] = this._overrides[n];
        for (i in Object.getOwnPropertyNames(this)) "function" != typeof this[i] && (this[i] = null)
    }, e.prototype.update = function() {
        var t, e, i, n = this._core.settings,
            s = this._core.clones().length / 2,
            r = s + this._core.items().length,
            a = n.center || n.autoWidth || n.dotData ? 1 : n.dotsEach || n.items;
        if ("page" !== n.slideBy && (n.slideBy = Math.min(n.slideBy, n.items)), n.dots || "page" == n.slideBy)
            for (this._pages = [], t = s, e = 0, i = 0; r > t; t++)(e >= a || 0 === e) && (this._pages.push({
                start: t - s,
                end: t - s + a - 1
            }), e = 0, ++i), e += this._core.mergers(this._core.relative(t))
    }, e.prototype.draw = function() {
        var e, i, n = "",
            s = this._core.settings,
            r = (this._core.$stage.children(), this._core.relative(this._core.current()));
        if (!s.nav || s.loop || s.navRewind || (this._controls.$previous.toggleClass("disabled", 0 >= r), this._controls.$next.toggleClass("disabled", r >= this._core.maximum())), this._controls.$previous.toggle(s.nav), this._controls.$next.toggle(s.nav), s.dots) {
            if (e = this._pages.length - this._controls.$indicators.children().length, s.dotData && 0 !== e) {
                for (i = 0; i < this._controls.$indicators.children().length; i++) n += this._templates[this._core.relative(i)];
                this._controls.$indicators.html(n)
            } else e > 0 ? (n = new Array(e + 1).join(this._templates[0]), this._controls.$indicators.append(n)) : 0 > e && this._controls.$indicators.children().slice(e).remove();
            this._controls.$indicators.find(".active").removeClass("active"), this._controls.$indicators.children().eq(t.inArray(this.current(), this._pages)).addClass("active")
        }
        this._controls.$indicators.toggle(s.dots)
    }, e.prototype.onTrigger = function(e) {
        var i = this._core.settings;
        e.page = {
            index: t.inArray(this.current(), this._pages),
            count: this._pages.length,
            size: i && (i.center || i.autoWidth || i.dotData ? 1 : i.dotsEach || i.items)
        }
    }, e.prototype.current = function() {
        var e = this._core.relative(this._core.current());
        return t.grep(this._pages, function(t) {
            return t.start <= e && t.end >= e
        }).pop()
    }, e.prototype.getPosition = function(e) {
        var i, n, s = this._core.settings;
        return "page" == s.slideBy ? (i = t.inArray(this.current(), this._pages), n = this._pages.length, e ? ++i : --i, i = this._pages[(i % n + n) % n].start) : (i = this._core.relative(this._core.current()), n = this._core.items().length, e ? i += s.slideBy : i -= s.slideBy), i
    }, e.prototype.next = function(e) {
        t.proxy(this._overrides.to, this._core)(this.getPosition(!0), e)
    }, e.prototype.prev = function(e) {
        t.proxy(this._overrides.to, this._core)(this.getPosition(!1), e)
    }, e.prototype.to = function(e, i, n) {
        var s;
        n ? t.proxy(this._overrides.to, this._core)(e, i) : (s = this._pages.length, t.proxy(this._overrides.to, this._core)(this._pages[(e % s + s) % s].start, i))
    }, t.fn.owlCarousel.Constructor.Plugins.Navigation = e
}(window.Zepto || window.jQuery, window, document),
function(t, e) {
    "use strict";
    var i = function(n) {
        this._core = n, this._hashes = {}, this.$element = this._core.$element, this._handlers = {
            "initialized.owl.carousel": t.proxy(function() {
                "URLHash" == this._core.settings.startPosition && t(e).trigger("hashchange.owl.navigation")
            }, this),
            "prepared.owl.carousel": t.proxy(function(e) {
                var i = t(e.content).find("[data-hash]").andSelf("[data-hash]").attr("data-hash");
                this._hashes[i] = e.content
            }, this)
        }, this._core.options = t.extend({}, i.Defaults, this._core.options), this.$element.on(this._handlers), t(e).on("hashchange.owl.navigation", t.proxy(function() {
            var t = e.location.hash.substring(1),
                i = this._core.$stage.children(),
                n = this._hashes[t] && i.index(this._hashes[t]) || 0;
            return t ? void this._core.to(n, !1, !0) : !1
        }, this))
    };
    i.Defaults = {
        URLhashListener: !1
    }, i.prototype.destroy = function() {
        var i, n;
        t(e).off("hashchange.owl.navigation");
        for (i in this._handlers) this._core.$element.off(i, this._handlers[i]);
        for (n in Object.getOwnPropertyNames(this)) "function" != typeof this[n] && (this[n] = null)
    }, t.fn.owlCarousel.Constructor.Plugins.Hash = i
}(window.Zepto || window.jQuery, window, document), ! function(t) {
    function e(e) {
        return t(e).filter(function() {
            return t(this).is(":appeared")
        })
    }

    function i() {
        a = !1;
        for (var t = 0, i = s.length; i > t; t++) {
            var n = e(s[t]);
            if (n.trigger("appear", [n]), u[t]) {
                var r = u[t].not(n);
                r.trigger("disappear", [r])
            }
            u[t] = n
        }
    }

    function n(t) {
        s.push(t), u.push()
    }
    var s = [],
        r = !1,
        a = !1,
        o = {
            interval: 250,
            force_process: !1
        },
        l = t(window),
        u = [];
    t.expr[":"].appeared = function(e) {
        var i = t(e);
        if (!i.is(":visible")) return !1;
        var n = l.scrollLeft(),
            s = l.scrollTop(),
            r = i.offset(),
            a = r.left,
            o = r.top;
        return o + i.height() >= s && o - (i.data("appear-top-offset") || 0) <= s + l.height() && a + i.width() >= n && a - (i.data("appear-left-offset") || 0) <= n + l.width() ? !0 : !1
    }, t.fn.extend({
        appear: function(e) {
            var s = t.extend({}, o, e || {}),
                l = this.selector || this;
            if (!r) {
                var u = function() {
                    a || (a = !0, setTimeout(i, s.interval))
                };
                t(window).scroll(u).resize(u), r = !0
            }
            return s.force_process && setTimeout(i, s.interval), n(l), t(l)
        }
    }), t.extend({
        force_appear: function() {
            return r ? (i(), !0) : !1
        }
    })
}(function() {
    return "undefined" != typeof module ? require("jquery") : jQuery
}());
var TxtType = function(t, e, i) {
    this.toRotate = e, this.el = t, this.loopNum = 0, this.period = parseInt(i, 10) || 2e3, this.txt = "", this.tick(), this.isDeleting = !1
};
TxtType.prototype.tick = function() {
        var t = this.loopNum % this.toRotate.length,
            e = this.toRotate[t];
        this.isDeleting ? this.txt = e.substring(0, this.txt.length - 1) : this.txt = e.substring(0, this.txt.length + 1), this.el.innerHTML = '<span class="wrap">' + this.txt + "</span>";
        var i = this,
            n = 200 - 100 * Math.random();
        this.isDeleting && (n /= 2), this.isDeleting || this.txt !== e ? this.isDeleting && "" === this.txt && (this.isDeleting = !1, this.loopNum++, n = 500) : (n = this.period, this.isDeleting = !0), setTimeout(function() {
            i.tick()
        }, n)
    }, window.onload = function() {
        for (var t = document.getElementsByClassName("typewrite"), e = 0; e < t.length; e++) {
            var i = t[e].getAttribute("data-type"),
                n = t[e].getAttribute("data-period");
            i && new TxtType(t[e], JSON.parse(i), n)
        }
        var s = document.createElement("style");
        s.type = "text/css", document.body.appendChild(s)
    }, ! function(t) {
        "function" == typeof define && define.amd ? define(["jquery"], t) : t("object" == typeof exports ? require("jquery") : window.jQuery || window.Zepto)
    }(function(t) {
        var e, i, n, s, r, a, o = "Close",
            l = "BeforeClose",
            u = "AfterClose",
            c = "BeforeAppend",
            d = "MarkupParse",
            h = "Open",
            p = "Change",
            m = "mfp",
            f = "." + m,
            g = "mfp-ready",
            v = "mfp-removing",
            y = "mfp-prevent-close",
            w = function() {},
            x = !!window.jQuery,
            b = t(window),
            _ = function(t, i) {
                e.ev.on(m + t + f, i)
            },
            C = function(e, i, n, s) {
                var r = document.createElement("div");
                return r.className = "mfp-" + e, n && (r.innerHTML = n), s ? i && i.appendChild(r) : (r = t(r), i && r.appendTo(i)), r
            },
            F = function(i, n) {
                e.ev.triggerHandler(m + i, n), e.st.callbacks && (i = i.charAt(0).toLowerCase() + i.slice(1), e.st.callbacks[i] && e.st.callbacks[i].apply(e, t.isArray(n) ? n : [n]))
            },
            T = function(i) {
                return i === a && e.currTemplate.closeBtn || (e.currTemplate.closeBtn = t(e.st.closeMarkup.replace("%title%", e.st.tClose)), a = i), e.currTemplate.closeBtn
            },
            E = function() {
                t.magnificPopup.instance || (e = new w, e.init(), t.magnificPopup.instance = e)
            },
            k = function() {
                var t = document.createElement("p").style,
                    e = ["ms", "O", "Moz", "Webkit"];
                if (void 0 !== t.transition) return !0;
                for (; e.length;)
                    if (e.pop() + "Transition" in t) return !0;
                return !1
            };
        w.prototype = {
            constructor: w,
            init: function() {
                var i = navigator.appVersion;
                e.isIE7 = -1 !== i.indexOf("MSIE 7."), e.isIE8 = -1 !== i.indexOf("MSIE 8."), e.isLowIE = e.isIE7 || e.isIE8, e.isAndroid = /android/gi.test(i), e.isIOS = /iphone|ipad|ipod/gi.test(i), e.supportsTransition = k(), e.probablyMobile = e.isAndroid || e.isIOS || /(Opera Mini)|Kindle|webOS|BlackBerry|(Opera Mobi)|(Windows Phone)|IEMobile/i.test(navigator.userAgent), n = t(document), e.popupsCache = {}
            },
            open: function(i) {
                var s;
                if (i.isObj === !1) {
                    e.items = i.items.toArray(), e.index = 0;
                    var a, o = i.items;
                    for (s = 0; s < o.length; s++)
                        if (a = o[s], a.parsed && (a = a.el[0]), a === i.el[0]) {
                            e.index = s;
                            break
                        }
                } else e.items = t.isArray(i.items) ? i.items : [i.items], e.index = i.index || 0;
                if (e.isOpen) return void e.updateItemHTML();
                e.types = [], r = "", i.mainEl && i.mainEl.length ? e.ev = i.mainEl.eq(0) : e.ev = n, i.key ? (e.popupsCache[i.key] || (e.popupsCache[i.key] = {}), e.currTemplate = e.popupsCache[i.key]) : e.currTemplate = {}, e.st = t.extend(!0, {}, t.magnificPopup.defaults, i), e.fixedContentPos = "auto" === e.st.fixedContentPos ? !e.probablyMobile : e.st.fixedContentPos, e.st.modal && (e.st.closeOnContentClick = !1, e.st.closeOnBgClick = !1, e.st.showCloseBtn = !1, e.st.enableEscapeKey = !1), e.bgOverlay || (e.bgOverlay = C("bg").on("click" + f, function() {
                    e.close()
                }), e.wrap = C("wrap").attr("tabindex", -1).on("click" + f, function(t) {
                    e._checkIfClose(t.target) && e.close()
                }), e.container = C("container", e.wrap)), e.contentContainer = C("content"), e.st.preloader && (e.preloader = C("preloader", e.container, e.st.tLoading));
                var l = t.magnificPopup.modules;
                for (s = 0; s < l.length; s++) {
                    var u = l[s];
                    u = u.charAt(0).toUpperCase() + u.slice(1), e["init" + u].call(e)
                }
                F("BeforeOpen"), e.st.showCloseBtn && (e.st.closeBtnInside ? (_(d, function(t, e, i, n) {
                    i.close_replaceWith = T(n.type)
                }), r += " mfp-close-btn-in") : e.wrap.append(T())), e.st.alignTop && (r += " mfp-align-top"), e.fixedContentPos ? e.wrap.css({
                    overflow: e.st.overflowY,
                    overflowX: "hidden",
                    overflowY: e.st.overflowY
                }) : e.wrap.css({
                    top: b.scrollTop(),
                    position: "absolute"
                }), (e.st.fixedBgPos === !1 || "auto" === e.st.fixedBgPos && !e.fixedContentPos) && e.bgOverlay.css({
                    height: n.height(),
                    position: "absolute"
                }), e.st.enableEscapeKey && n.on("keyup" + f, function(t) {
                    27 === t.keyCode && e.close()
                }), b.on("resize" + f, function() {
                    e.updateSize()
                }), e.st.closeOnContentClick || (r += " mfp-auto-cursor"), r && e.wrap.addClass(r);
                var c = e.wH = b.height(),
                    p = {};
                if (e.fixedContentPos && e._hasScrollBar(c)) {
                    var m = e._getScrollbarSize();
                    m && (p.marginRight = m)
                }
                e.fixedContentPos && (e.isIE7 ? t("body, html").css("overflow", "hidden") : p.overflow = "hidden");
                var v = e.st.mainClass;
                return e.isIE7 && (v += " mfp-ie7"), v && e._addClassToMFP(v), e.updateItemHTML(), F("BuildControls"), t("html").css(p), e.bgOverlay.add(e.wrap).prependTo(e.st.prependTo || t(document.body)), e._lastFocusedEl = document.activeElement, setTimeout(function() {
                    e.content ? (e._addClassToMFP(g), e._setFocus()) : e.bgOverlay.addClass(g), n.on("focusin" + f, e._onFocusIn)
                }, 16), e.isOpen = !0, e.updateSize(c), F(h), i
            },
            close: function() {
                e.isOpen && (F(l), e.isOpen = !1, e.st.removalDelay && !e.isLowIE && e.supportsTransition ? (e._addClassToMFP(v), setTimeout(function() {
                    e._close()
                }, e.st.removalDelay)) : e._close())
            },
            _close: function() {
                F(o);
                var i = v + " " + g + " ";
                if (e.bgOverlay.detach(), e.wrap.detach(), e.container.empty(), e.st.mainClass && (i += e.st.mainClass + " "), e._removeClassFromMFP(i), e.fixedContentPos) {
                    var s = {
                        marginRight: ""
                    };
                    e.isIE7 ? t("body, html").css("overflow", "") : s.overflow = "", t("html").css(s)
                }
                n.off("keyup" + f + " focusin" + f), e.ev.off(f), e.wrap.attr("class", "mfp-wrap").removeAttr("style"), e.bgOverlay.attr("class", "mfp-bg"), e.container.attr("class", "mfp-container"), !e.st.showCloseBtn || e.st.closeBtnInside && e.currTemplate[e.currItem.type] !== !0 || e.currTemplate.closeBtn && e.currTemplate.closeBtn.detach(), e.st.autoFocusLast && e._lastFocusedEl && t(e._lastFocusedEl).focus(), e.currItem = null, e.content = null, e.currTemplate = null, e.prevHeight = 0, F(u)
            },
            updateSize: function(t) {
                if (e.isIOS) {
                    var i = document.documentElement.clientWidth / window.innerWidth,
                        n = window.innerHeight * i;
                    e.wrap.css("height", n), e.wH = n
                } else e.wH = t || b.height();
                e.fixedContentPos || e.wrap.css("height", e.wH), F("Resize")
            },
            updateItemHTML: function() {
                var i = e.items[e.index];
                e.contentContainer.detach(), e.content && e.content.detach(), i.parsed || (i = e.parseEl(e.index));
                var n = i.type;
                if (F("BeforeChange", [e.currItem ? e.currItem.type : "", n]), e.currItem = i, !e.currTemplate[n]) {
                    var r = e.st[n] ? e.st[n].markup : !1;
                    F("FirstMarkupParse", r), r ? e.currTemplate[n] = t(r) : e.currTemplate[n] = !0
                }
                s && s !== i.type && e.container.removeClass("mfp-" + s + "-holder");
                var a = e["get" + n.charAt(0).toUpperCase() + n.slice(1)](i, e.currTemplate[n]);
                e.appendContent(a, n), i.preloaded = !0, F(p, i), s = i.type, e.container.prepend(e.contentContainer), F("AfterChange")
            },
            appendContent: function(t, i) {
                e.content = t, t ? e.st.showCloseBtn && e.st.closeBtnInside && e.currTemplate[i] === !0 ? e.content.find(".mfp-close").length || e.content.append(T()) : e.content = t : e.content = "", F(c), e.container.addClass("mfp-" + i + "-holder"), e.contentContainer.append(e.content)
            },
            parseEl: function(i) {
                var n, s = e.items[i];
                if (s.tagName ? s = {
                        el: t(s)
                    } : (n = s.type, s = {
                        data: s,
                        src: s.src
                    }), s.el) {
                    for (var r = e.types, a = 0; a < r.length; a++)
                        if (s.el.hasClass("mfp-" + r[a])) {
                            n = r[a];
                            break
                        }
                    s.src = s.el.attr("data-mfp-src"), s.src || (s.src = s.el.attr("href"))
                }
                return s.type = n || e.st.type || "inline", s.index = i, s.parsed = !0, e.items[i] = s, F("ElementParse", s), e.items[i]
            },
            addGroup: function(t, i) {
                var n = function(n) {
                    n.mfpEl = this, e._openClick(n, t, i)
                };
                i || (i = {});
                var s = "click.magnificPopup";
                i.mainEl = t, i.items ? (i.isObj = !0, t.off(s).on(s, n)) : (i.isObj = !1, i.delegate ? t.off(s).on(s, i.delegate, n) : (i.items = t, t.off(s).on(s, n)))
            },
            _openClick: function(i, n, s) {
                var r = void 0 !== s.midClick ? s.midClick : t.magnificPopup.defaults.midClick;
                if (r || !(2 === i.which || i.ctrlKey || i.metaKey || i.altKey || i.shiftKey)) {
                    var a = void 0 !== s.disableOn ? s.disableOn : t.magnificPopup.defaults.disableOn;
                    if (a)
                        if (t.isFunction(a)) {
                            if (!a.call(e)) return !0
                        } else if (b.width() < a) return !0;
                    i.type && (i.preventDefault(), e.isOpen && i.stopPropagation()), s.el = t(i.mfpEl), s.delegate && (s.items = n.find(s.delegate)), e.open(s)
                }
            },
            updateStatus: function(t, n) {
                if (e.preloader) {
                    i !== t && e.container.removeClass("mfp-s-" + i), n || "loading" !== t || (n = e.st.tLoading);
                    var s = {
                        status: t,
                        text: n
                    };
                    F("UpdateStatus", s), t = s.status, n = s.text, e.preloader.html(n), e.preloader.find("a").on("click", function(t) {
                        t.stopImmediatePropagation()
                    }), e.container.addClass("mfp-s-" + t), i = t
                }
            },
            _checkIfClose: function(i) {
                if (!t(i).hasClass(y)) {
                    var n = e.st.closeOnContentClick,
                        s = e.st.closeOnBgClick;
                    if (n && s) return !0;
                    if (!e.content || t(i).hasClass("mfp-close") || e.preloader && i === e.preloader[0]) return !0;
                    if (i === e.content[0] || t.contains(e.content[0], i)) {
                        if (n) return !0
                    } else if (s && t.contains(document, i)) return !0;
                    return !1
                }
            },
            _addClassToMFP: function(t) {
                e.bgOverlay.addClass(t), e.wrap.addClass(t)
            },
            _removeClassFromMFP: function(t) {
                this.bgOverlay.removeClass(t), e.wrap.removeClass(t)
            },
            _hasScrollBar: function(t) {
                return (e.isIE7 ? n.height() : document.body.scrollHeight) > (t || b.height())
            },
            _setFocus: function() {
                (e.st.focus ? e.content.find(e.st.focus).eq(0) : e.wrap).focus()
            },
            _onFocusIn: function(i) {
                return i.target === e.wrap[0] || t.contains(e.wrap[0], i.target) ? void 0 : (e._setFocus(), !1)
            },
            _parseMarkup: function(e, i, n) {
                var s;
                n.data && (i = t.extend(n.data, i)), F(d, [e, i, n]), t.each(i, function(t, i) {
                    if (void 0 === i || i === !1) return !0;
                    if (s = t.split("_"), s.length > 1) {
                        var n = e.find(f + "-" + s[0]);
                        if (n.length > 0) {
                            var r = s[1];
                            "replaceWith" === r ? n[0] !== i[0] && n.replaceWith(i) : "img" === r ? n.is("img") ? n.attr("src", i) : n.replaceWith('<img src="' + i + '" class="' + n.attr("class") + '" />') : n.attr(s[1], i);
                        }
                    } else e.find(f + "-" + t).html(i)
                })
            },
            _getScrollbarSize: function() {
                if (void 0 === e.scrollbarSize) {
                    var t = document.createElement("div");
                    t.style.cssText = "width: 99px; height: 99px; overflow: scroll; position: absolute; top: -9999px;", document.body.appendChild(t), e.scrollbarSize = t.offsetWidth - t.clientWidth, document.body.removeChild(t)
                }
                return e.scrollbarSize
            }
        }, t.magnificPopup = {
            instance: null,
            proto: w.prototype,
            modules: [],
            open: function(e, i) {
                return E(), e = e ? t.extend(!0, {}, e) : {}, e.isObj = !0, e.index = i || 0, this.instance.open(e)
            },
            close: function() {
                return t.magnificPopup.instance && t.magnificPopup.instance.close()
            },
            registerModule: function(e, i) {
                i.options && (t.magnificPopup.defaults[e] = i.options), t.extend(this.proto, i.proto), this.modules.push(e)
            },
            defaults: {
                disableOn: 0,
                key: null,
                midClick: !1,
                mainClass: "",
                preloader: !0,
                focus: "",
                closeOnContentClick: !1,
                closeOnBgClick: !0,
                closeBtnInside: !0,
                showCloseBtn: !0,
                enableEscapeKey: !0,
                modal: !1,
                alignTop: !1,
                removalDelay: 0,
                prependTo: null,
                fixedContentPos: "auto",
                fixedBgPos: "auto",
                overflowY: "auto",
                closeMarkup: '<button title="%title%" type="button" class="mfp-close">&#215;</button>',
                tClose: "Close (Esc)",
                tLoading: "Loading...",
                autoFocusLast: !0
            }
        }, t.fn.magnificPopup = function(i) {
            E();
            var n = t(this);
            if ("string" == typeof i)
                if ("open" === i) {
                    var s, r = x ? n.data("magnificPopup") : n[0].magnificPopup,
                        a = parseInt(arguments[1], 10) || 0;
                    r.items ? s = r.items[a] : (s = n, r.delegate && (s = s.find(r.delegate)), s = s.eq(a)), e._openClick({
                        mfpEl: s
                    }, n, r)
                } else e.isOpen && e[i].apply(e, Array.prototype.slice.call(arguments, 1));
            else i = t.extend(!0, {}, i), x ? n.data("magnificPopup", i) : n[0].magnificPopup = i, e.addGroup(n, i);
            return n
        };
        var S, D, $, z = "inline",
            j = function() {
                $ && (D.after($.addClass(S)).detach(), $ = null)
            };
        t.magnificPopup.registerModule(z, {
            options: {
                hiddenClass: "hide",
                markup: "",
                tNotFound: "Content not found"
            },
            proto: {
                initInline: function() {
                    e.types.push(z), _(o + "." + z, function() {
                        j()
                    })
                },
                getInline: function(i, n) {
                    if (j(), i.src) {
                        var s = e.st.inline,
                            r = t(i.src);
                        if (r.length) {
                            var a = r[0].parentNode;
                            a && a.tagName && (D || (S = s.hiddenClass, D = C(S), S = "mfp-" + S), $ = r.after(D).detach().removeClass(S)), e.updateStatus("ready")
                        } else e.updateStatus("error", s.tNotFound), r = t("<div>");
                        return i.inlineElement = r, r
                    }
                    return e.updateStatus("ready"), e._parseMarkup(n, {}, i), n
                }
            }
        });
        var M, I = "ajax",
            P = function() {
                M && t(document.body).removeClass(M)
            },
            A = function() {
                P(), e.req && e.req.abort()
            };
        t.magnificPopup.registerModule(I, {
            options: {
                settings: null,
                cursor: "mfp-ajax-cur",
                tError: '<a href="%url%">The content</a> could not be loaded.'
            },
            proto: {
                initAjax: function() {
                    e.types.push(I), M = e.st.ajax.cursor, _(o + "." + I, A), _("BeforeChange." + I, A)
                },
                getAjax: function(i) {
                    M && t(document.body).addClass(M), e.updateStatus("loading");
                    var n = t.extend({
                        url: i.src,
                        success: function(n, s, r) {
                            var a = {
                                data: n,
                                xhr: r
                            };
                            F("ParseAjax", a), e.appendContent(t(a.data), I), i.finished = !0, P(), e._setFocus(), setTimeout(function() {
                                e.wrap.addClass(g)
                            }, 16), e.updateStatus("ready"), F("AjaxContentAdded")
                        },
                        error: function() {
                            P(), i.finished = i.loadError = !0, e.updateStatus("error", e.st.ajax.tError.replace("%url%", i.src))
                        }
                    }, e.st.ajax.settings);
                    return e.req = t.ajax(n), ""
                }
            }
        });
        var L, O = function(i) {
            if (i.data && void 0 !== i.data.title) return i.data.title;
            var n = e.st.image.titleSrc;
            if (n) {
                if (t.isFunction(n)) return n.call(e, i);
                if (i.el) return i.el.attr(n) || ""
            }
            return ""
        };
        t.magnificPopup.registerModule("image", {
            options: {
                markup: '<div class="mfp-figure"><div class="mfp-close"></div><figure><div class="mfp-img"></div><figcaption><div class="mfp-bottom-bar"><div class="mfp-title"></div><div class="mfp-counter"></div></div></figcaption></figure></div>',
                cursor: "mfp-zoom-out-cur",
                titleSrc: "title",
                verticalFit: !0,
                tError: '<a href="%url%">The image</a> could not be loaded.'
            },
            proto: {
                initImage: function() {
                    var i = e.st.image,
                        n = ".image";
                    e.types.push("image"), _(h + n, function() {
                        "image" === e.currItem.type && i.cursor && t(document.body).addClass(i.cursor)
                    }), _(o + n, function() {
                        i.cursor && t(document.body).removeClass(i.cursor), b.off("resize" + f)
                    }), _("Resize" + n, e.resizeImage), e.isLowIE && _("AfterChange", e.resizeImage)
                },
                resizeImage: function() {
                    var t = e.currItem;
                    if (t && t.img && e.st.image.verticalFit) {
                        var i = 0;
                        e.isLowIE && (i = parseInt(t.img.css("padding-top"), 10) + parseInt(t.img.css("padding-bottom"), 10)), t.img.css("max-height", e.wH - i)
                    }
                },
                _onImageHasSize: function(t) {
                    t.img && (t.hasSize = !0, L && clearInterval(L), t.isCheckingImgSize = !1, F("ImageHasSize", t), t.imgHidden && (e.content && e.content.removeClass("mfp-loading"), t.imgHidden = !1))
                },
                findImageSize: function(t) {
                    var i = 0,
                        n = t.img[0],
                        s = function(r) {
                            L && clearInterval(L), L = setInterval(function() {
                                return n.naturalWidth > 0 ? void e._onImageHasSize(t) : (i > 200 && clearInterval(L), i++, void(3 === i ? s(10) : 40 === i ? s(50) : 100 === i && s(500)))
                            }, r)
                        };
                    s(1)
                },
                getImage: function(i, n) {
                    var s = 0,
                        r = function() {
                            i && (i.img[0].complete ? (i.img.off(".mfploader"), i === e.currItem && (e._onImageHasSize(i), e.updateStatus("ready")), i.hasSize = !0, i.loaded = !0, F("ImageLoadComplete")) : (s++, 200 > s ? setTimeout(r, 100) : a()))
                        },
                        a = function() {
                            i && (i.img.off(".mfploader"), i === e.currItem && (e._onImageHasSize(i), e.updateStatus("error", o.tError.replace("%url%", i.src))), i.hasSize = !0, i.loaded = !0, i.loadError = !0)
                        },
                        o = e.st.image,
                        l = n.find(".mfp-img");
                    if (l.length) {
                        var u = document.createElement("img");
                        u.className = "mfp-img", i.el && i.el.find("img").length && (u.alt = i.el.find("img").attr("alt")), i.img = t(u).on("load.mfploader", r).on("error.mfploader", a), u.src = i.src, l.is("img") && (i.img = i.img.clone()), u = i.img[0], u.naturalWidth > 0 ? i.hasSize = !0 : u.width || (i.hasSize = !1)
                    }
                    return e._parseMarkup(n, {
                        title: O(i),
                        img_replaceWith: i.img
                    }, i), e.resizeImage(), i.hasSize ? (L && clearInterval(L), i.loadError ? (n.addClass("mfp-loading"), e.updateStatus("error", o.tError.replace("%url%", i.src))) : (n.removeClass("mfp-loading"), e.updateStatus("ready")), n) : (e.updateStatus("loading"), i.loading = !0, i.hasSize || (i.imgHidden = !0, n.addClass("mfp-loading"), e.findImageSize(i)), n)
                }
            }
        });
        var R, q = function() {
            return void 0 === R && (R = void 0 !== document.createElement("p").style.MozTransform), R
        };
        t.magnificPopup.registerModule("zoom", {
            options: {
                enabled: !1,
                easing: "ease-in-out",
                duration: 300,
                opener: function(t) {
                    return t.is("img") ? t : t.find("img")
                }
            },
            proto: {
                initZoom: function() {
                    var t, i = e.st.zoom,
                        n = ".zoom";
                    if (i.enabled && e.supportsTransition) {
                        var s, r, a = i.duration,
                            u = function(t) {
                                var e = t.clone().removeAttr("style").removeAttr("class").addClass("mfp-animated-image"),
                                    n = "all " + i.duration / 1e3 + "s " + i.easing,
                                    s = {
                                        position: "fixed",
                                        zIndex: 9999,
                                        left: 0,
                                        top: 0,
                                        "-webkit-backface-visibility": "hidden"
                                    },
                                    r = "transition";
                                return s["-webkit-" + r] = s["-moz-" + r] = s["-o-" + r] = s[r] = n, e.css(s), e
                            },
                            c = function() {
                                e.content.css("visibility", "visible")
                            };
                        _("BuildControls" + n, function() {
                            if (e._allowZoom()) {
                                if (clearTimeout(s), e.content.css("visibility", "hidden"), t = e._getItemToZoom(), !t) return void c();
                                r = u(t), r.css(e._getOffset()), e.wrap.append(r), s = setTimeout(function() {
                                    r.css(e._getOffset(!0)), s = setTimeout(function() {
                                        c(), setTimeout(function() {
                                            r.remove(), t = r = null, F("ZoomAnimationEnded")
                                        }, 16)
                                    }, a)
                                }, 16)
                            }
                        }), _(l + n, function() {
                            if (e._allowZoom()) {
                                if (clearTimeout(s), e.st.removalDelay = a, !t) {
                                    if (t = e._getItemToZoom(), !t) return;
                                    r = u(t)
                                }
                                r.css(e._getOffset(!0)), e.wrap.append(r), e.content.css("visibility", "hidden"), setTimeout(function() {
                                    r.css(e._getOffset())
                                }, 16)
                            }
                        }), _(o + n, function() {
                            e._allowZoom() && (c(), r && r.remove(), t = null)
                        })
                    }
                },
                _allowZoom: function() {
                    return "image" === e.currItem.type
                },
                _getItemToZoom: function() {
                    return e.currItem.hasSize ? e.currItem.img : !1
                },
                _getOffset: function(i) {
                    var n;
                    n = i ? e.currItem.img : e.st.zoom.opener(e.currItem.el || e.currItem);
                    var s = n.offset(),
                        r = parseInt(n.css("padding-top"), 10),
                        a = parseInt(n.css("padding-bottom"), 10);
                    s.top -= t(window).scrollTop() - r;
                    var o = {
                        width: n.width(),
                        height: (x ? n.innerHeight() : n[0].offsetHeight) - a - r
                    };
                    return q() ? o["-moz-transform"] = o.transform = "translate(" + s.left + "px," + s.top + "px)" : (o.left = s.left, o.top = s.top), o
                }
            }
        });
        var H = "iframe",
            N = "//about:blank",
            B = function(t) {
                if (e.currTemplate[H]) {
                    var i = e.currTemplate[H].find("iframe");
                    i.length && (t || (i[0].src = N), e.isIE8 && i.css("display", t ? "block" : "none"))
                }
            };
        t.magnificPopup.registerModule(H, {
            options: {
                markup: '<div class="mfp-iframe-scaler"><div class="mfp-close"></div><a href="#business-x-plan-section" class="a-btn btn-more reg"><i class="fa fa-usd" aria-hidden="true"></i>Зарегистрироваться</a><iframe class="mfp-iframe" src="//about:blank" frameborder="0" allowfullscreen></iframe></div>',
                srcAction: "iframe_src",
                patterns: {
                    youtube: {
                        index: "youtube.com",
                        id: "v=",
                        src: "//www.youtube.com/embed/%id%?autoplay=1"
                    },
                    vimeo: {
                        index: "vimeo.com/",
                        id: "/",
                        src: "//player.vimeo.com/video/%id%?autoplay=1"
                    },
                    gmaps: {
                        index: "//maps.google.",
                        src: "%id%&output=embed"
                    }
                }
            },
            proto: {
                initIframe: function() {
                    e.types.push(H), _("BeforeChange", function(t, e, i) {
                        e !== i && (e === H ? B() : i === H && B(!0))
                    }), _(o + "." + H, function() {
                        B()
                    })
                },
                getIframe: function(i, n) {
                    var s = i.src,
                        r = e.st.iframe;
                    t.each(r.patterns, function() {
                        return s.indexOf(this.index) > -1 ? (this.id && (s = "string" == typeof this.id ? s.substr(s.lastIndexOf(this.id) + this.id.length, s.length) : this.id.call(this, s)), s = this.src.replace("%id%", s), !1) : void 0
                    });
                    var a = {};
                    return r.srcAction && (a[r.srcAction] = s), e._parseMarkup(n, a, i), e.updateStatus("ready"), n
                }
            }
        });
        var X = function(t) {
                var i = e.items.length;
                return t > i - 1 ? t - i : 0 > t ? i + t : t
            },
            W = function(t, e, i) {
                return t.replace(/%curr%/gi, e + 1).replace(/%total%/gi, i)
            };
        t.magnificPopup.registerModule("gallery", {
            options: {
                enabled: !1,
                arrowMarkup: '<button title="%title%" type="button" class="mfp-arrow mfp-arrow-%dir%"></button>',
                preload: [0, 2],
                navigateByImgClick: !0,
                arrows: !0,
                tPrev: "Previous (Left arrow key)",
                tNext: "Next (Right arrow key)",
                tCounter: "%curr% of %total%"
            },
            proto: {
                initGallery: function() {
                    var i = e.st.gallery,
                        s = ".mfp-gallery",
                        a = Boolean(t.fn.mfpFastClick);
                    return e.direction = !0, i && i.enabled ? (r += " mfp-gallery", _(h + s, function() {
                        i.navigateByImgClick && e.wrap.on("click" + s, ".mfp-img", function() {
                            return e.items.length > 1 ? (e.next(), !1) : void 0
                        }), n.on("keydown" + s, function(t) {
                            37 === t.keyCode ? e.prev() : 39 === t.keyCode && e.next()
                        })
                    }), _("UpdateStatus" + s, function(t, i) {
                        i.text && (i.text = W(i.text, e.currItem.index, e.items.length))
                    }), _(d + s, function(t, n, s, r) {
                        var a = e.items.length;
                        s.counter = a > 1 ? W(i.tCounter, r.index, a) : ""
                    }), _("BuildControls" + s, function() {
                        if (e.items.length > 1 && i.arrows && !e.arrowLeft) {
                            var n = i.arrowMarkup,
                                s = e.arrowLeft = t(n.replace(/%title%/gi, i.tPrev).replace(/%dir%/gi, "left")).addClass(y),
                                r = e.arrowRight = t(n.replace(/%title%/gi, i.tNext).replace(/%dir%/gi, "right")).addClass(y),
                                o = a ? "mfpFastClick" : "click";
                            s[o](function() {
                                e.prev()
                            }), r[o](function() {
                                e.next()
                            }), e.isIE7 && (C("b", s[0], !1, !0), C("a", s[0], !1, !0), C("b", r[0], !1, !0), C("a", r[0], !1, !0)), e.container.append(s.add(r))
                        }
                    }), _(p + s, function() {
                        e._preloadTimeout && clearTimeout(e._preloadTimeout), e._preloadTimeout = setTimeout(function() {
                            e.preloadNearbyImages(), e._preloadTimeout = null
                        }, 16)
                    }), void _(o + s, function() {
                        n.off(s), e.wrap.off("click" + s), e.arrowLeft && a && e.arrowLeft.add(e.arrowRight).destroyMfpFastClick(), e.arrowRight = e.arrowLeft = null
                    })) : !1
                },
                next: function() {
                    e.direction = !0, e.index = X(e.index + 1), e.updateItemHTML()
                },
                prev: function() {
                    e.direction = !1, e.index = X(e.index - 1), e.updateItemHTML()
                },
                goTo: function(t) {
                    e.direction = t >= e.index, e.index = t, e.updateItemHTML()
                },
                preloadNearbyImages: function() {
                    var t, i = e.st.gallery.preload,
                        n = Math.min(i[0], e.items.length),
                        s = Math.min(i[1], e.items.length);
                    for (t = 1; t <= (e.direction ? s : n); t++) e._preloadItem(e.index + t);
                    for (t = 1; t <= (e.direction ? n : s); t++) e._preloadItem(e.index - t)
                },
                _preloadItem: function(i) {
                    if (i = X(i), !e.items[i].preloaded) {
                        var n = e.items[i];
                        n.parsed || (n = e.parseEl(i)), F("LazyLoad", n), "image" === n.type && (n.img = t('<img class="mfp-img" />').on("load.mfploader", function() {
                            n.hasSize = !0
                        }).on("error.mfploader", function() {
                            n.hasSize = !0, n.loadError = !0, F("LazyLoadError", n)
                        }).attr("src", n.src)), n.preloaded = !0
                    }
                }
            }
        });
        var Y = "retina";
        t.magnificPopup.registerModule(Y, {
                options: {
                    replaceSrc: function(t) {
                        return t.src.replace(/\.\w+$/, function(t) {
                            return "@2x" + t
                        })
                    },
                    ratio: 1
                },
                proto: {
                    initRetina: function() {
                        if (window.devicePixelRatio > 1) {
                            var t = e.st.retina,
                                i = t.ratio;
                            i = isNaN(i) ? i() : i, i > 1 && (_("ImageHasSize." + Y, function(t, e) {
                                e.img.css({
                                    "max-width": e.img[0].naturalWidth / i,
                                    width: "100%"
                                })
                            }), _("ElementParse." + Y, function(e, n) {
                                n.src = t.replaceSrc(n, i)
                            }))
                        }
                    }
                }
            }),
            function() {
                var e = 1e3,
                    i = "ontouchstart" in window,
                    n = function() {
                        b.off("touchmove" + r + " touchend" + r)
                    },
                    s = "mfpFastClick",
                    r = "." + s;
                t.fn.mfpFastClick = function(s) {
                    return t(this).each(function() {
                        var a, o = t(this);
                        if (i) {
                            var l, u, c, d, h, p;
                            o.on("touchstart" + r, function(t) {
                                d = !1, p = 1, h = t.originalEvent ? t.originalEvent.touches[0] : t.touches[0], u = h.clientX, c = h.clientY, b.on("touchmove" + r, function(t) {
                                    h = t.originalEvent ? t.originalEvent.touches : t.touches, p = h.length, h = h[0], (Math.abs(h.clientX - u) > 10 || Math.abs(h.clientY - c) > 10) && (d = !0, n())
                                }).on("touchend" + r, function(t) {
                                    n(), d || p > 1 || (a = !0, t.preventDefault(), clearTimeout(l), l = setTimeout(function() {
                                        a = !1
                                    }, e), s())
                                })
                            })
                        }
                        o.on("click" + r, function() {
                            a || s()
                        })
                    })
                }, t.fn.destroyMfpFastClick = function() {
                    t(this).off("touchstart" + r + " click" + r), i && b.off("touchmove" + r + " touchend" + r)
                }
            }(), E()
    }), window.matchMedia || (window.matchMedia = function() {
        "use strict";
        var t = window.styleMedia || window.media;
        if (!t) {
            var e = document.createElement("style"),
                i = document.getElementsByTagName("script")[0],
                n = null;
            e.type = "text/css", e.id = "matchmediajs-test", i.parentNode.insertBefore(e, i), n = "getComputedStyle" in window && window.getComputedStyle(e, null) || e.currentStyle, t = {
                matchMedium: function(t) {
                    var i = "@media " + t + "{ #matchmediajs-test { width: 1px; } }";
                    return e.styleSheet ? e.styleSheet.cssText = i : e.textContent = i, "1px" === n.width
                }
            }
        }
        return function(e) {
            return {
                matches: t.matchMedium(e || "all"),
                media: e || "all"
            }
        }
    }()), ! function(t) {
        "use strict";
        t.ajaxChimp = {
            responses: {
                "We have sent you a confirmation email": 0,
                "Please enter a value": 1,
                "An email address must contain a single @": 2,
                "The domain portion of the email address is invalid (the portion after the @: )": 3,
                "The username portion of the email address is invalid (the portion before the @: )": 4,
                "This email address looks fake or invalid. Please enter a real email address": 5
            },
            translations: {
                en: null
            },
            init: function(e, i) {
                t(e).ajaxChimp(i)
            }
        }, t.fn.ajaxChimp = function(e) {
            return t(this).each(function(i, n) {
                var s = t(n),
                    r = s.find("input[type=email]"),
                    a = s.find("label[for=" + r.attr("id") + "]"),
                    o = t.extend({
                        url: s.attr("action"),
                        language: "en"
                    }, e),
                    l = o.url.replace("/post?", "/post-json?").concat("&c=?");
                s.attr("novalidate", "true"), r.attr("name", "EMAIL"), s.submit(function() {
                    function e(e) {
                        if ("success" === e.result) i = "We have sent you a confirmation email", a.removeClass("error").addClass("valid"), r.removeClass("error").addClass("valid"), a.html('<span class="text-success">We have sent you a confirmation email</span>');
                        else {
                            r.removeClass("valid").addClass("error"), a.removeClass("valid").addClass("error");
                            var n = -1;
                            try {
                                var s = e.msg.split(" - ", 2);
                                if (void 0 === s[1]) i = e.msg;
                                else {
                                    var l = parseInt(s[0], 10);
                                    l.toString() === s[0] ? (n = s[0], i = s[1]) : (n = -1, i = e.msg)
                                }
                                a.html('<span style="color:#fff;" >Something worng! Try again</span>')
                            } catch (u) {
                                n = -1, i = e.msg
                            }
                        }
                        "en" !== o.language && void 0 !== t.ajaxChimp.responses[i] && t.ajaxChimp.translations && t.ajaxChimp.translations[o.language] && t.ajaxChimp.translations[o.language][t.ajaxChimp.responses[i]] && (i = t.ajaxChimp.translations[o.language][t.ajaxChimp.responses[i]]), a.show(2e3), o.callback && o.callback(e)
                    }
                    var i, n = {},
                        u = s.serializeArray();
                    t.each(u, function(t, e) {
                        n[e.name] = e.value
                    }), t.ajax({
                        url: l,
                        data: n,
                        success: e,
                        dataType: "jsonp",
                        error: function(t, e) {
                            console.log("mailchimp ajax submit error: " + e)
                        }
                    });
                    var c = "Submitting...";
                    return "en" !== o.language && t.ajaxChimp.translations && t.ajaxChimp.translations[o.language] && t.ajaxChimp.translations[o.language].submit && (c = t.ajaxChimp.translations[o.language].submit), a.html(c).show(2e3), !1
                })
            }), this
        }
    }(jQuery),
    function(t) {
        "use strict";
        t.fn.twittie = function() {
            var e = arguments[0] instanceof Object ? arguments[0] : {},
                i = "function" == typeof arguments[0] ? arguments[0] : arguments[1],
                n = t.extend({
                    username: null,
                    list: null,
                    hashtag: null,
                    count: 10,
                    hideReplies: !1,
                    dateFormat: "%b/%d/%Y",
                    template: "{{date}} - {{tweet}}",
                    apiPath: "./api/tweet.php",
                    loadingText: "Loading..."
                }, e);
            n.list && !n.username && t.error("If you want to fetch tweets from a list, you must define the username of the list owner.");
            var s = function(t) {
                    var e = t.replace(/(https?:\/\/([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)/gi, '<a href="$1" target="_blank" title="Visit this link">$1</a>').replace(/#([a-zA-Z0-9_]+)/g, '<a href="https://twitter.com/search?q=%23$1&src=hash" target="_blank" title="Search for #$1">#$1</a>').replace(/@([a-zA-Z0-9_]+)/g, '<a href="https://twitter.com/$1" target="_blank" title="$1 on Twitter">@$1</a>');
                    return e
                },
                r = function(t) {
                    var e = t.split(" ");
                    t = new Date(Date.parse(e[1] + " " + e[2] + ", " + e[5] + " " + e[3] + " UTC"));
                    for (var i = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], s = {
                            "%d": t.getDate(),
                            "%m": t.getMonth() + 1,
                            "%b": i[t.getMonth()].substr(0, 3),
                            "%B": i[t.getMonth()],
                            "%y": String(t.getFullYear()).slice(-2),
                            "%Y": t.getFullYear()
                        }, r = n.dateFormat, a = n.dateFormat.match(/%[dmbByY]/g), o = 0, l = a.length; l > o; o++) r = r.replace(a[o], s[a[o]]);
                    return r
                },
                a = function(t) {
                    for (var e = n.template, i = ["date", "tweet", "avatar", "url", "retweeted", "screen_name", "user_name"], s = 0, r = i.length; r > s; s++) e = e.replace(new RegExp("{{" + i[s] + "}}", "gi"), t[i[s]]);
                    return e
                };
            this.html("<span>" + n.loadingText + "</span>");
            var o = this;
            t.getJSON(n.apiPath, {
                username: n.username,
                list: n.list,
                hashtag: n.hashtag,
                count: n.count,
                exclude_replies: n.hideReplies
            }, function(t) {
                o.find("span").fadeOut("fast", function() {
                    o.html("<ul></ul>");
                    for (var e = 0; e < n.count; e++) {
                        var l = !1;
                        if (t[e]) l = t[e];
                        else {
                            if (void 0 === t.statuses || !t.statuses[e]) break;
                            l = t.statuses[e]
                        }
                        var u = {
                            user_name: l.user.name,
                            date: r(l.created_at),
                            tweet: s(l.retweeted ? "RT @" + l.user.screen_name + ": " + l.retweeted_status.text : l.text),
                            avatar: '<img src="' + l.user.profile_image_url + '" />',
                            url: "https://twitter.com/" + l.user.screen_name + "/status/" + l.id_str,
                            retweeted: l.retweeted,
                            screen_name: s("@" + l.user.screen_name)
                        };
                        o.find("ul").append("<li>" + a(u) + "</li>")
                    }
                    "function" == typeof i && i()
                })
            })
        }
    }(jQuery),
    function(t) {
        function e() {
            if (t.fn.ajaxSubmit.debug) {
                var e = "[jquery.form] " + Array.prototype.join.call(arguments, "");
                window.console && window.console.log ? window.console.log(e) : window.opera && window.opera.postError && window.opera.postError(e)
            }
        }
        t.fn.ajaxSubmit = function(i) {
            function n(e) {
                for (var n = new FormData, s = 0; s < e.length; s++) "file" != e[s].type && n.append(e[s].name, e[s].value);
                if (l.find("input:file:enabled").each(function() {
                        var e = t(this).attr("name"),
                            i = this.files;
                        if (e)
                            for (var s = 0; s < i.length; s++) n.append(e, i[s])
                    }), i.extraData)
                    for (var r in i.extraData) n.append(r, i.extraData[r]);
                i.data = null;
                var a = t.extend(!0, {}, t.ajaxSettings, i, {
                    contentType: !1,
                    processData: !1,
                    cache: !1,
                    type: "POST"
                });
                a.context = a.context || a, a.data = null;
                var o = a.beforeSend;
                a.beforeSend = function(t, e) {
                    e.data = n, t.upload && (t.upload.onprogress = function(t) {
                        e.progress(t.position, t.total)
                    }), o && o.call(e, t, i)
                }, t.ajax(a)
            }

            function s(n) {
                function s(t) {
                    var e = t.contentWindow ? t.contentWindow.document : t.contentDocument ? t.contentDocument : t.document;
                    return e
                }

                function a() {
                    function i() {
                        try {
                            var t = s(f).readyState;
                            e("state = " + t), "uninitialized" == t.toLowerCase() && setTimeout(i, 50)
                        } catch (n) {
                            e("Server abort: ", n, " (", n.name, ")"), o(F), x && clearTimeout(x), x = void 0
                        }
                    }
                    var n = l.attr("target"),
                        a = l.attr("action");
                    b.setAttribute("target", p), r || b.setAttribute("method", "POST"), a != d.url && b.setAttribute("action", d.url), d.skipEncodingOverride || r && !/post/i.test(r) || l.attr({
                        encoding: "multipart/form-data",
                        enctype: "multipart/form-data"
                    }), d.timeout && (x = setTimeout(function() {
                        w = !0, o(C)
                    }, d.timeout));
                    var u = [];
                    try {
                        if (d.extraData)
                            for (var c in d.extraData) u.push(t('<input type="hidden" name="' + c + '">').attr("value", d.extraData[c]).appendTo(b)[0]);
                        d.iframeTarget || (m.appendTo("body"), f.attachEvent ? f.attachEvent("onload", o) : f.addEventListener("load", o, !1)), setTimeout(i, 15), b.submit()
                    } finally {
                        b.setAttribute("action", a), n ? b.setAttribute("target", n) : l.removeAttr("target"), t(u).remove()
                    }
                }

                function o(i) {
                    if (!g.aborted && !D) {
                        try {
                            S = s(f)
                        } catch (n) {
                            e("cannot access response document: ", n), i = F
                        }
                        if (i === C && g) return void g.abort("timeout");
                        if (i == F && g) return void g.abort("server abort");
                        if (S && S.location.href != d.iframeSrc || w) {
                            f.detachEvent ? f.detachEvent("onload", o) : f.removeEventListener("load", o, !1);
                            var r, a = "success";
                            try {
                                if (w) throw "timeout";
                                var l = "xml" == d.dataType || S.XMLDocument || t.isXMLDoc(S);
                                if (e("isXml=" + l), !l && window.opera && (null == S.body || "" == S.body.innerHTML) && --$) return e("requeing onLoad callback, DOM not available"), void setTimeout(o, 250);
                                var u = S.body ? S.body : S.documentElement;
                                g.responseText = u ? u.innerHTML : null, g.responseXML = S.XMLDocument ? S.XMLDocument : S, l && (d.dataType = "xml"), g.getResponseHeader = function(t) {
                                    var e = {
                                        "content-type": d.dataType
                                    };
                                    return e[t]
                                }, u && (g.status = Number(u.getAttribute("status")) || g.status, g.statusText = u.getAttribute("statusText") || g.statusText);
                                var c = (d.dataType || "").toLowerCase(),
                                    p = /(json|script|text)/.test(c);
                                if (p || d.textarea) {
                                    var v = S.getElementsByTagName("textarea")[0];
                                    if (v) g.responseText = v.value, g.status = Number(v.getAttribute("status")) || g.status, g.statusText = v.getAttribute("statusText") || g.statusText;
                                    else if (p) {
                                        var y = S.getElementsByTagName("pre")[0],
                                            b = S.getElementsByTagName("body")[0];
                                        y ? g.responseText = y.textContent ? y.textContent : y.innerText : b && (g.responseText = b.textContent ? b.textContent : b.innerText)
                                    }
                                } else "xml" != c || g.responseXML || null == g.responseText || (g.responseXML = z(g.responseText));
                                try {
                                    k = M(g, c, d)
                                } catch (i) {
                                    a = "parsererror", g.error = r = i || a
                                }
                            } catch (i) {
                                e("error caught: ", i), a = "error", g.error = r = i || a
                            }
                            g.aborted && (e("upload aborted"), a = null), g.status && (a = g.status >= 200 && g.status < 300 || 304 === g.status ? "success" : "error"), "success" === a ? (d.success && d.success.call(d.context, k, "success", g), h && t.event.trigger("ajaxSuccess", [g, d])) : a && (void 0 == r && (r = g.statusText), d.error && d.error.call(d.context, g, a, r), h && t.event.trigger("ajaxError", [g, d, r])), h && t.event.trigger("ajaxComplete", [g, d]), h && !--t.active && t.event.trigger("ajaxStop"), d.complete && d.complete.call(d.context, g, a), D = !0, d.timeout && clearTimeout(x), setTimeout(function() {
                                d.iframeTarget || m.remove(), g.responseXML = null
                            }, 100)
                        }
                    }
                }
                var u, c, d, h, p, m, f, g, v, y, w, x, b = l[0],
                    _ = !!t.fn.prop;
                if (n)
                    if (_)
                        for (c = 0; c < n.length; c++) u = t(b[n[c].name]), u.prop("disabled", !1);
                    else
                        for (c = 0; c < n.length; c++) u = t(b[n[c].name]), u.removeAttr("disabled");
                if (t(":input[name=submit],:input[id=submit]", b).length) return void alert('Error: Form elements must not have name or id of "submit".');
                if (d = t.extend(!0, {}, t.ajaxSettings, i), d.context = d.context || d, p = "jqFormIO" + (new Date).getTime(), d.iframeTarget ? (m = t(d.iframeTarget), y = m.attr("name"), null == y ? m.attr("name", p) : p = y) : (m = t('<iframe name="' + p + '" src="../../varient-2/scripts/' + d.iframeSrc + '" />'), m.css({
                        position: "absolute",
                        top: "-1000px",
                        left: "-1000px"
                    })), f = m[0], g = {
                        aborted: 0,
                        responseText: null,
                        responseXML: null,
                        status: 0,
                        statusText: "n/a",
                        getAllResponseHeaders: function() {},
                        getResponseHeader: function() {},
                        setRequestHeader: function() {},
                        abort: function(i) {
                            var n = "timeout" === i ? "timeout" : "aborted";
                            e("aborting upload... " + n), this.aborted = 1, m.attr("src", d.iframeSrc), g.error = n, d.error && d.error.call(d.context, g, n, i), h && t.event.trigger("ajaxError", [g, d, n]), d.complete && d.complete.call(d.context, g, n)
                        }
                    }, h = d.global, h && !t.active++ && t.event.trigger("ajaxStart"), h && t.event.trigger("ajaxSend", [g, d]), d.beforeSend && d.beforeSend.call(d.context, g, d) === !1) return void(d.global && t.active--);
                if (!g.aborted) {
                    v = b.clk, v && (y = v.name, y && !v.disabled && (d.extraData = d.extraData || {}, d.extraData[y] = v.value, "image" == v.type && (d.extraData[y + ".x"] = b.clk_x, d.extraData[y + ".y"] = b.clk_y)));
                    var C = 1,
                        F = 2,
                        T = t("meta[name=csrf-token]").attr("content"),
                        E = t("meta[name=csrf-param]").attr("content");
                    E && T && (d.extraData = d.extraData || {}, d.extraData[E] = T), d.forceSync ? a() : setTimeout(a, 10);
                    var k, S, D, $ = 50,
                        z = t.parseXML || function(t, e) {
                            return window.ActiveXObject ? (e = new ActiveXObject("Microsoft.XMLDOM"), e.async = "false", e.loadXML(t)) : e = (new DOMParser).parseFromString(t, "text/xml"), e && e.documentElement && "parsererror" != e.documentElement.nodeName ? e : null
                        },
                        j = t.parseJSON || function(t) {
                            return window.eval("(" + t + ")")
                        },
                        M = function(e, i, n) {
                            var s = e.getResponseHeader("content-type") || "",
                                r = "xml" === i || !i && s.indexOf("xml") >= 0,
                                a = r ? e.responseXML : e.responseText;
                            return r && "parsererror" === a.documentElement.nodeName && t.error && t.error("parsererror"), n && n.dataFilter && (a = n.dataFilter(a, i)), "string" == typeof a && ("json" === i || !i && s.indexOf("json") >= 0 ? a = j(a) : ("script" === i || !i && s.indexOf("javascript") >= 0) && t.globalEval(a)), a
                        }
                }
            }
            if (!this.length) return e("ajaxSubmit: skipping submit process - no element selected"), this;
            var r, a, o, l = this;
            "function" == typeof i && (i = {
                success: i
            }), r = this.attr("method"), a = this.attr("action"), o = "string" == typeof a ? t.trim(a) : "", o = o || window.location.href || "", o && (o = (o.match(/^([^#]+)/) || [])[1]), i = t.extend(!0, {
                url: o,
                success: t.ajaxSettings.success,
                type: r || "GET",
                iframeSrc: /^https/i.test(window.location.href || "") ? "javascript:false" : "about:blank"
            }, i);
            var u = {};
            if (this.trigger("form-pre-serialize", [this, i, u]), u.veto) return e("ajaxSubmit: submit vetoed via form-pre-serialize trigger"), this;
            if (i.beforeSerialize && i.beforeSerialize(this, i) === !1) return e("ajaxSubmit: submit aborted via beforeSerialize callback"), this;
            var c = i.traditional;
            void 0 === c && (c = t.ajaxSettings.traditional);
            var d, h = this.formToArray(i.semantic);
            if (i.data && (i.extraData = i.data, d = t.param(i.data, c)), i.beforeSubmit && i.beforeSubmit(h, this, i) === !1) return e("ajaxSubmit: submit aborted via beforeSubmit callback"), this;
            if (this.trigger("form-submit-validate", [h, this, i, u]), u.veto) return e("ajaxSubmit: submit vetoed via form-submit-validate trigger"), this;
            var p = t.param(h, c);
            d && (p = p ? p + "&" + d : d), "GET" == i.type.toUpperCase() ? (i.url += (i.url.indexOf("?") >= 0 ? "&" : "?") + p, i.data = null) : i.data = p;
            var m = [];
            if (i.resetForm && m.push(function() {
                    l.resetForm()
                }), i.clearForm && m.push(function() {
                    l.clearForm(i.includeHidden)
                }), !i.dataType && i.target) {
                var f = i.success || function() {};
                m.push(function(e) {
                    var n = i.replaceTarget ? "replaceWith" : "html";
                    t(i.target)[n](e).each(f, arguments)
                })
            } else i.success && m.push(i.success);
            i.success = function(t, e, n) {
                for (var s = i.context || i, r = 0, a = m.length; a > r; r++) m[r].apply(s, [t, e, n || l, l])
            };
            var g = t("input:file:enabled[value]", this),
                v = g.length > 0,
                y = "multipart/form-data",
                w = l.attr("enctype") == y || l.attr("encoding") == y,
                x = !!(v && g.get(0).files && window.FormData);
            e("fileAPI :" + x);
            var b = (v || w) && !x;
            return i.iframe !== !1 && (i.iframe || b) ? i.closeKeepAlive ? t.get(i.closeKeepAlive, function() {
                s(h)
            }) : s(h) : (v || w) && x ? (i.progress = i.progress || t.noop, n(h)) : t.ajax(i), this.trigger("form-submit-notify", [this, i]), this
        }, t.fn.ajaxForm = function(i) {
            if (0 === this.length) {
                var n = {
                    s: this.selector,
                    c: this.context
                };
                return !t.isReady && n.s ? (e("DOM not ready, queuing ajaxForm"), t(function() {
                    t(n.s, n.c).ajaxForm(i)
                }), this) : (e("terminating; zero elements found by selector" + (t.isReady ? "" : " (DOM not ready)")), this)
            }
            return this.ajaxFormUnbind().bind("submit.form-plugin", function(e) {
                e.isDefaultPrevented() || (e.preventDefault(), t(this).ajaxSubmit(i))
            }).bind("click.form-plugin", function(e) {
                var i = e.target,
                    n = t(i);
                if (!n.is(":submit,input:image")) {
                    var s = n.closest(":submit");
                    if (0 == s.length) return;
                    i = s[0]
                }
                var r = this;
                if (r.clk = i, "image" == i.type)
                    if (void 0 != e.offsetX) r.clk_x = e.offsetX, r.clk_y = e.offsetY;
                    else if ("function" == typeof t.fn.offset) {
                    var a = n.offset();
                    r.clk_x = e.pageX - a.left, r.clk_y = e.pageY - a.top
                } else r.clk_x = e.pageX - i.offsetLeft, r.clk_y = e.pageY - i.offsetTop;
                setTimeout(function() {
                    r.clk = r.clk_x = r.clk_y = null
                }, 100)
            })
        }, t.fn.ajaxFormUnbind = function() {
            return this.unbind("submit.form-plugin click.form-plugin")
        }, t.fn.formToArray = function(e) {
            var i = [];
            if (0 === this.length) return i;
            var n = this[0],
                s = e ? n.getElementsByTagName("*") : n.elements;
            if (!s) return i;
            var r, a, o, l, u, c, d;
            for (r = 0, c = s.length; c > r; r++)
                if (u = s[r], o = u.name)
                    if (e && n.clk && "image" == u.type) u.disabled || n.clk != u || (i.push({
                        name: o,
                        value: t(u).val(),
                        type: u.type
                    }), i.push({
                        name: o + ".x",
                        value: n.clk_x
                    }, {
                        name: o + ".y",
                        value: n.clk_y
                    }));
                    else if (l = t.fieldValue(u, !0), l && l.constructor == Array)
                for (a = 0, d = l.length; d > a; a++) i.push({
                    name: o,
                    value: l[a]
                });
            else null !== l && "undefined" != typeof l && i.push({
                name: o,
                value: l,
                type: u.type
            });
            if (!e && n.clk) {
                var h = t(n.clk),
                    p = h[0];
                o = p.name, o && !p.disabled && "image" == p.type && (i.push({
                    name: o,
                    value: h.val()
                }), i.push({
                    name: o + ".x",
                    value: n.clk_x
                }, {
                    name: o + ".y",
                    value: n.clk_y
                }))
            }
            return i
        }, t.fn.formSerialize = function(e) {
            return t.param(this.formToArray(e))
        }, t.fn.fieldSerialize = function(e) {
            var i = [];
            return this.each(function() {
                var n = this.name;
                if (n) {
                    var s = t.fieldValue(this, e);
                    if (s && s.constructor == Array)
                        for (var r = 0, a = s.length; a > r; r++) i.push({
                            name: n,
                            value: s[r]
                        });
                    else null !== s && "undefined" != typeof s && i.push({
                        name: this.name,
                        value: s
                    })
                }
            }), t.param(i)
        }, t.fn.fieldValue = function(e) {
            for (var i = [], n = 0, s = this.length; s > n; n++) {
                var r = this[n],
                    a = t.fieldValue(r, e);
                null === a || "undefined" == typeof a || a.constructor == Array && !a.length || (a.constructor == Array ? t.merge(i, a) : i.push(a))
            }
            return i
        }, t.fieldValue = function(e, i) {
            var n = e.name,
                s = e.type,
                r = e.tagName.toLowerCase();
            if (void 0 === i && (i = !0), i && (!n || e.disabled || "reset" == s || "button" == s || ("checkbox" == s || "radio" == s) && !e.checked || ("submit" == s || "image" == s) && e.form && e.form.clk != e || "select" == r && -1 == e.selectedIndex)) return null;
            if ("select" == r) {
                var a = e.selectedIndex;
                if (0 > a) return null;
                for (var o = [], l = e.options, u = "select-one" == s, c = u ? a + 1 : l.length, d = u ? a : 0; c > d; d++) {
                    var h = l[d];
                    if (h.selected) {
                        var p = h.value;
                        if (p || (p = h.attributes && h.attributes.value && !h.attributes.value.specified ? h.text : h.value), u) return p;
                        o.push(p)
                    }
                }
                return o
            }
            return t(e).val()
        }, t.fn.clearForm = function(e) {
            return this.each(function() {
                t("input,select,textarea", this).clearFields(e)
            })
        }, t.fn.clearFields = t.fn.clearInputs = function(t) {
            var e = /^(?:color|date|datetime|email|month|number|password|range|search|tel|text|time|url|week)$/i;
            return this.each(function() {
                var i = this.type,
                    n = this.tagName.toLowerCase();
                e.test(i) || "textarea" == n || t && /hidden/.test(i) ? this.value = "" : "checkbox" == i || "radio" == i ? this.checked = !1 : "select" == n && (this.selectedIndex = -1)
            })
        }, t.fn.resetForm = function() {
            return this.each(function() {
                ("function" == typeof this.reset || "object" == typeof this.reset && !this.reset.nodeType) && this.reset()
            })
        }, t.fn.enable = function(t) {
            return void 0 === t && (t = !0), this.each(function() {
                this.disabled = !t
            })
        }, t.fn.selected = function(e) {
            return void 0 === e && (e = !0), this.each(function() {
                var i = this.type;
                if ("checkbox" == i || "radio" == i) this.checked = e;
                else if ("option" == this.tagName.toLowerCase()) {
                    var n = t(this).parent("select");
                    e && n[0] && "select-one" == n[0].type && n.find("option").selected(!1), this.selected = e
                }
            })
        }, t.fn.ajaxSubmit.debug = !1
    }(jQuery), $(function() {
        $("#contact-form").validate({
            errorElement: "span",
            errorPlacement: function(t, e) {
                t.insertAfter($(e))
            },
            rules: {
                firstname: {
                    required: !0,
                    minlength: 3
                },
                lastname: {
                    required: !0,
                    minlength: 3
                },
                email: {
                    required: !0,
                    email: !0
                },
                subject: {
                    minlength: 8
                },
                message: {
                    required: !0,
                    minlength: 20
                }
            },
            messages: {
                firstname: {
                    required: "Please enter your first name.",
                    minlength: jQuery.format("At least {0} characters required.")
                },
                lastname: {
                    required: "Please enter your last name.",
                    minlength: jQuery.format("At least {0} characters required.")
                },
                email: {
                    required: "Email required.",
                    email: "Please enter a valid email."
                },
                subject: {
                    required: "Subject required.",
                    minlength: jQuery.format("At least {0} characters required.")
                },
                message: {
                    required: "Message required.",
                    minlength: jQuery.format("At least {0} characters required.")
                }
            },
            submitHandler: function(t) {
                return $("#send").text("Sending..."), $(t).ajaxSubmit({
                    success: function(t, e, i, n) {
                        $("#response").html(t).hide().slideDown(), $("#send").text("Send Message")
                    }
                }), !1
            }
        })
    }),
    function(t) {
        t.extend(t.fn, {
            validate: function(e) {
                if (this.length) {
                    var i = t.data(this[0], "validator");
                    return i ? i : (this.attr("novalidate", "novalidate"), i = new t.validator(e, this[0]), t.data(this[0], "validator", i), i.settings.onsubmit && (e = this.find("input, button"), e.filter(".cancel").click(function() {
                        i.cancelSubmit = !0
                    }), i.settings.submitHandler && e.filter(":submit").click(function() {
                        i.submitButton = this
                    }), this.submit(function(e) {
                        function n() {
                            if (i.settings.submitHandler) {
                                if (i.submitButton) var e = t("<input type='hidden'/>").attr("name", i.submitButton.name).val(i.submitButton.value).appendTo(i.currentForm);
                                return i.settings.submitHandler.call(i, i.currentForm), i.submitButton && e.remove(), !1
                            }
                            return !0
                        }
                        return i.settings.debug && e.preventDefault(), i.cancelSubmit ? (i.cancelSubmit = !1, n()) : i.form() ? i.pendingRequest ? (i.formSubmitted = !0, !1) : n() : (i.focusInvalid(), !1)
                    })), i)
                }
                e && e.debug && window.console && console.warn("nothing selected, can't validate, returning nothing")
            },
            valid: function() {
                if (t(this[0]).is("form")) return this.validate().form();
                var e = !0,
                    i = t(this[0].form).validate();
                return this.each(function() {
                    e &= i.element(this);
                }), e
            },
            removeAttrs: function(e) {
                var i = {},
                    n = this;
                return t.each(e.split(/\s/), function(t, e) {
                    i[e] = n.attr(e), n.removeAttr(e)
                }), i
            },
            rules: function(e, i) {
                var n = this[0];
                if (e) {
                    var s = t.data(n.form, "validator").settings,
                        r = s.rules,
                        a = t.validator.staticRules(n);
                    switch (e) {
                        case "add":
                            t.extend(a, t.validator.normalizeRule(i)), r[n.name] = a, i.messages && (s.messages[n.name] = t.extend(s.messages[n.name], i.messages));
                            break;
                        case "remove":
                            if (!i) return delete r[n.name], a;
                            var o = {};
                            return t.each(i.split(/\s/), function(t, e) {
                                o[e] = a[e], delete a[e]
                            }), o
                    }
                }
                return n = t.validator.normalizeRules(t.extend({}, t.validator.metadataRules(n), t.validator.classRules(n), t.validator.attributeRules(n), t.validator.staticRules(n)), n), n.required && (s = n.required, delete n.required, n = t.extend({
                    required: s
                }, n)), n
            }
        }), t.extend(t.expr[":"], {
            blank: function(e) {
                return !t.trim("" + e.value)
            },
            filled: function(e) {
                return !!t.trim("" + e.value)
            },
            unchecked: function(t) {
                return !t.checked
            }
        }), t.validator = function(e, i) {
            this.settings = t.extend(!0, {}, t.validator.defaults, e), this.currentForm = i, this.init()
        }, t.validator.format = function(e, i) {
            return 1 == arguments.length ? function() {
                var i = t.makeArray(arguments);
                return i.unshift(e), t.validator.format.apply(this, i)
            } : (arguments.length > 2 && i.constructor != Array && (i = t.makeArray(arguments).slice(1)), i.constructor != Array && (i = [i]), t.each(i, function(t, i) {
                e = e.replace(RegExp("\\{" + t + "\\}", "g"), i)
            }), e)
        }, t.extend(t.validator, {
            defaults: {
                messages: {},
                groups: {},
                rules: {},
                errorClass: "error",
                validClass: "valid",
                errorElement: "label",
                focusInvalid: !0,
                errorContainer: t([]),
                errorLabelContainer: t([]),
                onsubmit: !0,
                ignore: ":hidden",
                ignoreTitle: !1,
                onfocusin: function(t) {
                    this.lastActive = t, this.settings.focusCleanup && !this.blockFocusCleanup && (this.settings.unhighlight && this.settings.unhighlight.call(this, t, this.settings.errorClass, this.settings.validClass), this.addWrapper(this.errorsFor(t)).hide())
                },
                onfocusout: function(t) {
                    this.checkable(t) || !(t.name in this.submitted) && this.optional(t) || this.element(t)
                },
                onkeyup: function(t) {
                    (t.name in this.submitted || t == this.lastElement) && this.element(t)
                },
                onclick: function(t) {
                    t.name in this.submitted ? this.element(t) : t.parentNode.name in this.submitted && this.element(t.parentNode)
                },
                highlight: function(e, i, n) {
                    "radio" === e.type ? this.findByName(e.name).addClass(i).removeClass(n) : t(e).addClass(i).removeClass(n)
                },
                unhighlight: function(e, i, n) {
                    "radio" === e.type ? this.findByName(e.name).removeClass(i).addClass(n) : t(e).removeClass(i).addClass(n)
                }
            },
            setDefaults: function(e) {
                t.extend(t.validator.defaults, e)
            },
            messages: {
                required: "This field is required.",
                remote: "Please fix this field.",
                email: "Please enter a valid email address.",
                url: "Please enter a valid URL.",
                date: "Please enter a valid date.",
                dateISO: "Please enter a valid date (ISO).",
                number: "Please enter a valid number.",
                digits: "Please enter only digits.",
                creditcard: "Please enter a valid credit card number.",
                equalTo: "Please enter the same value again.",
                accept: "Please enter a value with a valid extension.",
                maxlength: t.validator.format("Please enter no more than {0} characters."),
                minlength: t.validator.format("Please enter at least {0} characters."),
                rangelength: t.validator.format("Please enter a value between {0} and {1} characters long."),
                range: t.validator.format("Please enter a value between {0} and {1}."),
                max: t.validator.format("Please enter a value less than or equal to {0}."),
                min: t.validator.format("Please enter a value greater than or equal to {0}.")
            },
            autoCreateRanges: !1,
            prototype: {
                init: function() {
                    function e(e) {
                        var i = t.data(this[0].form, "validator"),
                            n = "on" + e.type.replace(/^validate/, "");
                        i.settings[n] && i.settings[n].call(i, this[0], e)
                    }
                    this.labelContainer = t(this.settings.errorLabelContainer), this.errorContext = this.labelContainer.length && this.labelContainer || t(this.currentForm), this.containers = t(this.settings.errorContainer).add(this.settings.errorLabelContainer), this.submitted = {}, this.valueCache = {}, this.pendingRequest = 0, this.pending = {}, this.invalid = {}, this.reset();
                    var i = this.groups = {};
                    t.each(this.settings.groups, function(e, n) {
                        t.each(n.split(/\s/), function(t, n) {
                            i[n] = e
                        })
                    });
                    var n = this.settings.rules;
                    t.each(n, function(e, i) {
                        n[e] = t.validator.normalizeRule(i)
                    }), t(this.currentForm).validateDelegate("[type='text'], [type='password'], [type='file'], select, textarea, [type='number'], [type='search'] ,[type='tel'], [type='url'], [type='email'], [type='datetime'], [type='date'], [type='month'], [type='week'], [type='time'], [type='datetime-local'], [type='range'], [type='color'] ", "focusin focusout keyup", e).validateDelegate("[type='radio'], [type='checkbox'], select, option", "click", e), this.settings.invalidHandler && t(this.currentForm).bind("invalid-form.validate", this.settings.invalidHandler)
                },
                form: function() {
                    return this.checkForm(), t.extend(this.submitted, this.errorMap), this.invalid = t.extend({}, this.errorMap), this.valid() || t(this.currentForm).triggerHandler("invalid-form", [this]), this.showErrors(), this.valid()
                },
                checkForm: function() {
                    this.prepareForm();
                    for (var t = 0, e = this.currentElements = this.elements(); e[t]; t++) this.check(e[t]);
                    return this.valid()
                },
                element: function(e) {
                    this.lastElement = e = this.validationTargetFor(this.clean(e)), this.prepareElement(e), this.currentElements = t(e);
                    var i = this.check(e);
                    return i ? delete this.invalid[e.name] : this.invalid[e.name] = !0, this.numberOfInvalids() || (this.toHide = this.toHide.add(this.containers)), this.showErrors(), i
                },
                showErrors: function(e) {
                    if (e) {
                        t.extend(this.errorMap, e), this.errorList = [];
                        for (var i in e) this.errorList.push({
                            message: e[i],
                            element: this.findByName(i)[0]
                        });
                        this.successList = t.grep(this.successList, function(t) {
                            return !(t.name in e)
                        })
                    }
                    this.settings.showErrors ? this.settings.showErrors.call(this, this.errorMap, this.errorList) : this.defaultShowErrors()
                },
                resetForm: function() {
                    t.fn.resetForm && t(this.currentForm).resetForm(), this.submitted = {}, this.lastElement = null, this.prepareForm(), this.hideErrors(), this.elements().removeClass(this.settings.errorClass)
                },
                numberOfInvalids: function() {
                    return this.objectLength(this.invalid)
                },
                objectLength: function(t) {
                    var e, i = 0;
                    for (e in t) i++;
                    return i
                },
                hideErrors: function() {
                    this.addWrapper(this.toHide).hide()
                },
                valid: function() {
                    return 0 == this.size()
                },
                size: function() {
                    return this.errorList.length
                },
                focusInvalid: function() {
                    if (this.settings.focusInvalid) try {
                        t(this.findLastActive() || this.errorList.length && this.errorList[0].element || []).filter(":visible").focus().trigger("focusin")
                    } catch (e) {}
                },
                findLastActive: function() {
                    var e = this.lastActive;
                    return e && 1 == t.grep(this.errorList, function(t) {
                        return t.element.name == e.name
                    }).length && e
                },
                elements: function() {
                    var e = this,
                        i = {};
                    return t(this.currentForm).find("input, select, textarea").not(":submit, :reset, :image, [disabled]").not(this.settings.ignore).filter(function() {
                        return !this.name && e.settings.debug && window.console && console.error("%o has no name assigned", this), this.name in i || !e.objectLength(t(this).rules()) ? !1 : i[this.name] = !0
                    })
                },
                clean: function(e) {
                    return t(e)[0]
                },
                errors: function() {
                    return t(this.settings.errorElement + "." + this.settings.errorClass, this.errorContext)
                },
                reset: function() {
                    this.successList = [], this.errorList = [], this.errorMap = {}, this.toShow = t([]), this.toHide = t([]), this.currentElements = t([])
                },
                prepareForm: function() {
                    this.reset(), this.toHide = this.errors().add(this.containers)
                },
                prepareElement: function(t) {
                    this.reset(), this.toHide = this.errorsFor(t)
                },
                check: function(e) {
                    e = this.validationTargetFor(this.clean(e));
                    var i, n = t(e).rules(),
                        s = !1;
                    for (i in n) {
                        var r = {
                            method: i,
                            parameters: n[i]
                        };
                        try {
                            var a = t.validator.methods[i].call(this, e.value.replace(/\r/g, ""), e, r.parameters);
                            if ("dependency-mismatch" == a) s = !0;
                            else {
                                if (s = !1, "pending" == a) return void(this.toHide = this.toHide.not(this.errorsFor(e)));
                                if (!a) return this.formatAndAdd(e, r), !1
                            }
                        } catch (o) {
                            throw this.settings.debug && window.console && console.log("exception occured when checking element " + e.id + ", check the '" + r.method + "' method", o), o
                        }
                    }
                    return s ? void 0 : (this.objectLength(n) && this.successList.push(e), !0)
                },
                customMetaMessage: function(e, i) {
                    if (t.metadata) {
                        var n = this.settings.meta ? t(e).metadata()[this.settings.meta] : t(e).metadata();
                        return n && n.messages && n.messages[i]
                    }
                },
                customMessage: function(t, e) {
                    var i = this.settings.messages[t];
                    return i && (i.constructor == String ? i : i[e])
                },
                findDefined: function() {
                    for (var t = 0; t < arguments.length; t++)
                        if (void 0 !== arguments[t]) return arguments[t]
                },
                defaultMessage: function(e, i) {
                    return this.findDefined(this.customMessage(e.name, i), this.customMetaMessage(e, i), !this.settings.ignoreTitle && e.title || void 0, t.validator.messages[i], "<strong>Warning: No message defined for " + e.name + "</strong>")
                },
                formatAndAdd: function(t, e) {
                    var i = this.defaultMessage(t, e.method),
                        n = /\$?\{(\d+)\}/g;
                    "function" == typeof i ? i = i.call(this, e.parameters, t) : n.test(i) && (i = jQuery.format(i.replace(n, "{$1}"), e.parameters)), this.errorList.push({
                        message: i,
                        element: t
                    }), this.errorMap[t.name] = i, this.submitted[t.name] = i
                },
                addWrapper: function(t) {
                    return this.settings.wrapper && (t = t.add(t.parent(this.settings.wrapper))), t
                },
                defaultShowErrors: function() {
                    for (var t = 0; this.errorList[t]; t++) {
                        var e = this.errorList[t];
                        this.settings.highlight && this.settings.highlight.call(this, e.element, this.settings.errorClass, this.settings.validClass), this.showLabel(e.element, e.message)
                    }
                    if (this.errorList.length && (this.toShow = this.toShow.add(this.containers)), this.settings.success)
                        for (t = 0; this.successList[t]; t++) this.showLabel(this.successList[t]);
                    if (this.settings.unhighlight)
                        for (t = 0, e = this.validElements(); e[t]; t++) this.settings.unhighlight.call(this, e[t], this.settings.errorClass, this.settings.validClass);
                    this.toHide = this.toHide.not(this.toShow), this.hideErrors(), this.addWrapper(this.toShow).show()
                },
                validElements: function() {
                    return this.currentElements.not(this.invalidElements())
                },
                invalidElements: function() {
                    return t(this.errorList).map(function() {
                        return this.element
                    })
                },
                showLabel: function(e, i) {
                    var n = this.errorsFor(e);
                    n.length ? (n.removeClass(this.settings.validClass).addClass(this.settings.errorClass), n.attr("generated") && n.html(i)) : (n = t("<" + this.settings.errorElement + "/>").attr({
                        "for": this.idOrName(e),
                        generated: !0
                    }).addClass(this.settings.errorClass).html(i || ""), this.settings.wrapper && (n = n.hide().show().wrap("<" + this.settings.wrapper + "/>").parent()), this.labelContainer.append(n).length || (this.settings.errorPlacement ? this.settings.errorPlacement(n, t(e)) : n.insertAfter(e))), !i && this.settings.success && (n.text(""), "string" == typeof this.settings.success ? n.addClass(this.settings.success) : this.settings.success(n)), this.toShow = this.toShow.add(n)
                },
                errorsFor: function(e) {
                    var i = this.idOrName(e);
                    return this.errors().filter(function() {
                        return t(this).attr("for") == i
                    })
                },
                idOrName: function(t) {
                    return this.groups[t.name] || (this.checkable(t) ? t.name : t.id || t.name)
                },
                validationTargetFor: function(t) {
                    return this.checkable(t) && (t = this.findByName(t.name).not(this.settings.ignore)[0]), t
                },
                checkable: function(t) {
                    return /radio|checkbox/i.test(t.type)
                },
                findByName: function(e) {
                    var i = this.currentForm;
                    return t(document.getElementsByName(e)).map(function(t, n) {
                        return n.form == i && n.name == e && n || null
                    })
                },
                getLength: function(e, i) {
                    switch (i.nodeName.toLowerCase()) {
                        case "select":
                            return t("option:selected", i).length;
                        case "input":
                            if (this.checkable(i)) return this.findByName(i.name).filter(":checked").length
                    }
                    return e.length
                },
                depend: function(t, e) {
                    return this.dependTypes[typeof t] ? this.dependTypes[typeof t](t, e) : !0
                },
                dependTypes: {
                    "boolean": function(t) {
                        return t
                    },
                    string: function(e, i) {
                        return !!t(e, i.form).length
                    },
                    "function": function(t, e) {
                        return t(e)
                    }
                },
                optional: function(e) {
                    return !t.validator.methods.required.call(this, t.trim(e.value), e) && "dependency-mismatch"
                },
                startRequest: function(t) {
                    this.pending[t.name] || (this.pendingRequest++, this.pending[t.name] = !0)
                },
                stopRequest: function(e, i) {
                    this.pendingRequest--, this.pendingRequest < 0 && (this.pendingRequest = 0), delete this.pending[e.name], i && 0 == this.pendingRequest && this.formSubmitted && this.form() ? (t(this.currentForm).submit(), this.formSubmitted = !1) : !i && 0 == this.pendingRequest && this.formSubmitted && (t(this.currentForm).triggerHandler("invalid-form", [this]), this.formSubmitted = !1)
                },
                previousValue: function(e) {
                    return t.data(e, "previousValue") || t.data(e, "previousValue", {
                        old: null,
                        valid: !0,
                        message: this.defaultMessage(e, "remote")
                    })
                }
            },
            classRuleSettings: {
                required: {
                    required: !0
                },
                email: {
                    email: !0
                },
                url: {
                    url: !0
                },
                date: {
                    date: !0
                },
                dateISO: {
                    dateISO: !0
                },
                dateDE: {
                    dateDE: !0
                },
                number: {
                    number: !0
                },
                numberDE: {
                    numberDE: !0
                },
                digits: {
                    digits: !0
                },
                creditcard: {
                    creditcard: !0
                }
            },
            addClassRules: function(e, i) {
                e.constructor == String ? this.classRuleSettings[e] = i : t.extend(this.classRuleSettings, e)
            },
            classRules: function(e) {
                var i = {};
                return (e = t(e).attr("class")) && t.each(e.split(" "), function() {
                    this in t.validator.classRuleSettings && t.extend(i, t.validator.classRuleSettings[this])
                }), i
            },
            attributeRules: function(e) {
                var i = {};
                e = t(e);
                for (var n in t.validator.methods) {
                    var s;
                    (s = "required" === n && "function" == typeof t.fn.prop ? e.prop(n) : e.attr(n)) ? i[n] = s: e[0].getAttribute("type") === n && (i[n] = !0)
                }
                return i.maxlength && /-1|2147483647|524288/.test(i.maxlength) && delete i.maxlength, i
            },
            metadataRules: function(e) {
                if (!t.metadata) return {};
                var i = t.data(e.form, "validator").settings.meta;
                return i ? t(e).metadata()[i] : t(e).metadata()
            },
            staticRules: function(e) {
                var i = {},
                    n = t.data(e.form, "validator");
                return n.settings.rules && (i = t.validator.normalizeRule(n.settings.rules[e.name]) || {}), i
            },
            normalizeRules: function(e, i) {
                return t.each(e, function(n, s) {
                    if (s === !1) delete e[n];
                    else if (s.param || s.depends) {
                        var r = !0;
                        switch (typeof s.depends) {
                            case "string":
                                r = !!t(s.depends, i.form).length;
                                break;
                            case "function":
                                r = s.depends.call(i, i)
                        }
                        r ? e[n] = void 0 !== s.param ? s.param : !0 : delete e[n]
                    }
                }), t.each(e, function(n, s) {
                    e[n] = t.isFunction(s) ? s(i) : s
                }), t.each(["minlength", "maxlength", "min", "max"], function() {
                    e[this] && (e[this] = Number(e[this]))
                }), t.each(["rangelength", "range"], function() {
                    e[this] && (e[this] = [Number(e[this][0]), Number(e[this][1])])
                }), t.validator.autoCreateRanges && (e.min && e.max && (e.range = [e.min, e.max], delete e.min, delete e.max), e.minlength && e.maxlength && (e.rangelength = [e.minlength, e.maxlength], delete e.minlength, delete e.maxlength)), e.messages && delete e.messages, e
            },
            normalizeRule: function(e) {
                if ("string" == typeof e) {
                    var i = {};
                    t.each(e.split(/\s/), function() {
                        i[this] = !0
                    }), e = i
                }
                return e
            },
            addMethod: function(e, i, n) {
                t.validator.methods[e] = i, t.validator.messages[e] = void 0 != n ? n : t.validator.messages[e], i.length < 3 && t.validator.addClassRules(e, t.validator.normalizeRule(e))
            },
            methods: {
                required: function(e, i, n) {
                    if (!this.depend(n, i)) return "dependency-mismatch";
                    switch (i.nodeName.toLowerCase()) {
                        case "select":
                            return (e = t(i).val()) && e.length > 0;
                        case "input":
                            if (this.checkable(i)) return this.getLength(e, i) > 0;
                        default:
                            return t.trim(e).length > 0
                    }
                },
                remote: function(e, i, n) {
                    if (this.optional(i)) return "dependency-mismatch";
                    var s = this.previousValue(i);
                    if (this.settings.messages[i.name] || (this.settings.messages[i.name] = {}), s.originalMessage = this.settings.messages[i.name].remote, this.settings.messages[i.name].remote = s.message, n = "string" == typeof n && {
                            url: n
                        } || n, this.pending[i.name]) return "pending";
                    if (s.old === e) return s.valid;
                    s.old = e;
                    var r = this;
                    this.startRequest(i);
                    var a = {};
                    return a[i.name] = e, t.ajax(t.extend(!0, {
                        url: n,
                        mode: "abort",
                        port: "validate" + i.name,
                        dataType: "json",
                        data: a,
                        success: function(n) {
                            r.settings.messages[i.name].remote = s.originalMessage;
                            var a = n === !0;
                            if (a) {
                                var o = r.formSubmitted;
                                r.prepareElement(i), r.formSubmitted = o, r.successList.push(i), r.showErrors()
                            } else o = {}, n = n || r.defaultMessage(i, "remote"), o[i.name] = s.message = t.isFunction(n) ? n(e) : n, r.showErrors(o);
                            s.valid = a, r.stopRequest(i, a)
                        }
                    }, n)), "pending"
                },
                minlength: function(e, i, n) {
                    return this.optional(i) || this.getLength(t.trim(e), i) >= n
                },
                maxlength: function(e, i, n) {
                    return this.optional(i) || this.getLength(t.trim(e), i) <= n
                },
                rangelength: function(e, i, n) {
                    return e = this.getLength(t.trim(e), i), this.optional(i) || e >= n[0] && e <= n[1]
                },
                min: function(t, e, i) {
                    return this.optional(e) || t >= i
                },
                max: function(t, e, i) {
                    return this.optional(e) || i >= t
                },
                range: function(t, e, i) {
                    return this.optional(e) || t >= i[0] && t <= i[1]
                },
                email: function(t, e) {
                    return this.optional(e) || /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i.test(t)
                },
                url: function(t, e) {
                    return this.optional(e) || /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(t)
                },
                date: function(t, e) {
                    return this.optional(e) || !/Invalid|NaN/.test(new Date(t))
                },
                dateISO: function(t, e) {
                    return this.optional(e) || /^\d{4}[\/-]\d{1,2}[\/-]\d{1,2}$/.test(t)
                },
                number: function(t, e) {
                    return this.optional(e) || /^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/.test(t)
                },
                digits: function(t, e) {
                    return this.optional(e) || /^\d+$/.test(t)
                },
                creditcard: function(t, e) {
                    if (this.optional(e)) return "dependency-mismatch";
                    if (/[^0-9 -]+/.test(t)) return !1;
                    var i = 0,
                        n = 0,
                        s = !1;
                    t = t.replace(/\D/g, "");
                    for (var r = t.length - 1; r >= 0; r--) n = t.charAt(r), n = parseInt(n, 10), s && (n *= 2) > 9 && (n -= 9), i += n, s = !s;
                    return i % 10 == 0
                },
                accept: function(t, e, i) {
                    return i = "string" == typeof i ? i.replace(/,/g, "|") : "png|jpe?g|gif", this.optional(e) || t.match(RegExp(".(" + i + ")$", "i"))
                },
                equalTo: function(e, i, n) {
                    return n = t(n).unbind(".validate-equalTo").bind("blur.validate-equalTo", function() {
                        t(i).valid()
                    }), e == n.val()
                }
            }
        }), t.format = t.validator.format
    }(jQuery),
    function(t) {
        var e = {};
        if (t.ajaxPrefilter) t.ajaxPrefilter(function(t, i, n) {
            i = t.port, "abort" == t.mode && (e[i] && e[i].abort(), e[i] = n)
        });
        else {
            var i = t.ajax;
            t.ajax = function(n) {
                var s = ("port" in n ? n : t.ajaxSettings).port;
                return "abort" == ("mode" in n ? n : t.ajaxSettings).mode ? (e[s] && e[s].abort(), e[s] = i.apply(this, arguments)) : i.apply(this, arguments)
            }
        }
    }(jQuery),
    function(t) {
        !jQuery.event.special.focusin && !jQuery.event.special.focusout && document.addEventListener && t.each({
            focus: "focusin",
            blur: "focusout"
        }, function(e, i) {
            function n(e) {
                return e = t.event.fix(e), e.type = i, t.event.handle.call(this, e)
            }
            t.event.special[i] = {
                setup: function() {
                    this.addEventListener(e, n, !0)
                },
                teardown: function() {
                    this.removeEventListener(e, n, !0)
                },
                handler: function(e) {
                    return arguments[0] = t.event.fix(e), arguments[0].type = i, t.event.handle.apply(this, arguments)
                }
            }
        }), t.extend(t.fn, {
            validateDelegate: function(e, i, n) {
                return this.bind(i, function(i) {
                    var s = t(i.target);
                    return s.is(e) ? n.apply(s, arguments) : void 0
                })
            }
        })
    }(jQuery), ! function(t, e) {
        "function" == typeof define && define.amd ? define(["jquery"], e) : e("object" == typeof exports ? require("jquery") : t.jQuery)
    }(this, function(t) {
        "use strict";

        function e(t) {
            var e, i, n, s, r, a, o, l = {};
            for (r = t.replace(/\s*:\s*/g, ":").replace(/\s*,\s*/g, ",").split(","), o = 0, a = r.length; a > o && (i = r[o], -1 === i.search(/^(http|https|ftp):\/\//) && -1 !== i.search(":")); o++) e = i.indexOf(":"), n = i.substring(0, e), s = i.substring(e + 1), s || (s = void 0), "string" == typeof s && (s = "true" === s || ("false" === s ? !1 : s)), "string" == typeof s && (s = isNaN(s) ? s : +s), l[n] = s;
            return null == n && null == s ? t : l
        }

        function i(t) {
            t = "" + t;
            var e, i, n, s = t.split(/\s+/),
                r = "50%",
                a = "50%";
            for (n = 0, e = s.length; e > n; n++) i = s[n], "left" === i ? r = "0%" : "right" === i ? r = "100%" : "top" === i ? a = "0%" : "bottom" === i ? a = "100%" : "center" === i ? 0 === n ? r = "50%" : a = "50%" : 0 === n ? r = i : a = i;
            return {
                x: r,
                y: a
            }
        }

        function n(e, i) {
            var n = function() {
                i(this.src)
            };
            t('<img src="' + e + '.gif">').load(n), t('<img src="' + e + '.jpg">').load(n), t('<img src="' + e + '.jpeg">').load(n), t('<img src="' + e + '.png">').load(n)
        }

        function s(i, n, s) {
            if (this.$element = t(i), "string" == typeof n && (n = e(n)), s ? "string" == typeof s && (s = e(s)) : s = {}, "string" == typeof n) n = n.replace(/\.\w*$/, "");
            else if ("object" == typeof n)
                for (var r in n) n.hasOwnProperty(r) && (n[r] = n[r].replace(/\.\w*$/, ""));
            this.settings = t.extend({}, a, s), this.path = n;
            try {
                this.init()
            } catch (l) {
                if (l.message !== o) throw l
            }
        }
        var r = "vide",
            a = {
                volume: 1,
                playbackRate: 1,
                muted: !0,
                loop: !0,
                autoplay: !0,
                position: "50% 50%",
                posterType: "detect",
                resizing: !0,
                bgColor: "transparent",
                className: ""
            },
            o = "Not implemented";
        s.prototype.init = function() {
            var e, s, a = this,
                l = a.path,
                u = l,
                c = "",
                d = a.$element,
                h = a.settings,
                p = i(h.position),
                m = h.posterType;
            s = a.$wrapper = t("<div>").addClass(h.className).css({
                position: "absolute",
                "z-index": -1,
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                overflow: "hidden",
                "-webkit-background-size": "cover",
                "-moz-background-size": "cover",
                "-o-background-size": "cover",
                "background-size": "cover",
                "background-color": h.bgColor,
                "background-repeat": "no-repeat",
                "background-position": p.x + " " + p.y
            }), "object" == typeof l && (l.poster ? u = l.poster : l.mp4 ? u = l.mp4 : l.webm ? u = l.webm : l.ogv && (u = l.ogv)), "detect" === m ? n(u, function(t) {
                s.css("background-image", "url(" + t + ")")
            }) : "none" !== m && s.css("background-image", "url(" + u + "." + m + ")"), "static" === d.css("position") && d.css("position", "relative"), d.prepend(s), "object" == typeof l ? (l.mp4 && (c += '<source src="' + l.mp4 + '.mp4" type="video/mp4">'), l.webm && (c += '<source src="' + l.webm + '.webm" type="video/webm">'), l.ogv && (c += '<source src="' + l.ogv + '.ogv" type="video/ogg">'), e = a.$video = t("<video>" + c + "</video>")) : e = a.$video = t('<video><source src="' + l + '.mp4" type="video/mp4"><source src="' + l + '.webm" type="video/webm"><source src="' + l + '.ogv" type="video/ogg"></video>');
            try {
                e.prop({
                    autoplay: h.autoplay,
                    loop: h.loop,
                    volume: h.volume,
                    muted: h.muted,
                    defaultMuted: h.muted,
                    playbackRate: h.playbackRate,
                    defaultPlaybackRate: h.playbackRate
                })
            } catch (f) {
                throw new Error(o)
            }
            e.css({
                margin: "auto",
                position: "absolute",
                "z-index": -1,
                top: p.y,
                left: p.x,
                "-webkit-transform": "translate(-" + p.x + ", -" + p.y + ")",
                "-ms-transform": "translate(-" + p.x + ", -" + p.y + ")",
                "-moz-transform": "translate(-" + p.x + ", -" + p.y + ")",
                transform: "translate(-" + p.x + ", -" + p.y + ")",
                visibility: "hidden",
                opacity: 0
            }).one("canplaythrough." + r, function() {
                a.resize()
            }).one("playing." + r, function() {
                e.css({
                    visibility: "visible",
                    opacity: 1
                }), s.css("background-image", "none")
            }), d.on("resize." + r, function() {
                h.resizing && a.resize()
            }), s.append(e)
        }, s.prototype.getVideoObject = function() {
            return this.$video[0]
        }, s.prototype.resize = function() {
            if (this.$video) {
                var t = this.$wrapper,
                    e = this.$video,
                    i = e[0],
                    n = i.videoHeight,
                    s = i.videoWidth,
                    r = t.height(),
                    a = t.width();
                a / s > r / n ? e.css({
                    width: a + 2,
                    height: "auto"
                }) : e.css({
                    width: "auto",
                    height: r + 2
                })
            }
        }, s.prototype.destroy = function() {
            delete t[r].lookup[this.index], this.$video && this.$video.off(r), this.$element.off(r).removeData(r), this.$wrapper.remove()
        }, t[r] = {
            lookup: []
        }, t.fn[r] = function(e, i) {
            var n;
            return this.each(function() {
                n = t.data(this, r), n && n.destroy(), n = new s(this, e, i), n.index = t[r].lookup.push(n) - 1, t.data(this, r, n)
            }), this
        }, t(document).ready(function() {
            var e = t(window);
            e.on("resize." + r, function() {
                for (var e, i = t[r].lookup.length, n = 0; i > n; n++) e = t[r].lookup[n], e && e.settings.resizing && e.resize()
            }), e.on("unload." + r, function() {
                return !1
            }), t(document).find("[data-" + r + "-bg]").each(function(e, i) {
                var n = t(i),
                    s = n.data(r + "-options"),
                    a = n.data(r + "-bg");
                n[r](a, s)
            })
        })
    }), jQuery(document).ready(function(t) {
        "use strict";

        function e(e, i) {
            var n = e.offset(),
                s = n.top,
                r = s - i;
            t("body,html").animate({
                scrollTop: r
            }, 500)
        }

        function i(e) {
            "success" === e.result ? (t("#mailchimp .subscription-success").html('<i class="icon_check_alt2"></i>' + e.msg).fadeIn(1e3), t("#mailchimp .subscription-error").fadeOut(500)) : "error" === e.result && (t("#mailchimp .subscription-success").fadeOut(500), t("#mailchimp .subscription-error").html('<i class="icon_close_alt2"></i>' + e.msg).fadeIn(1e3))
        }

        function n() {
            var e = t("<div>", {
                id: "sc-icons",
                "class": "sc-icons"
            });
            return e
        }
        t(".spinner-wrap").fadeOut(), t(".preloader").delay(500).fadeOut("slow"), t(function() {
            t(".navbar").offset().top > 50 ? t(".navbar-fixed-top").addClass("top-nav-collapse") : t(".navbar-fixed-top").removeClass("top-nav-collapse")
        }), t(window).scroll(function() {
            t(".navbar").offset().top > 50 ? t(".navbar-fixed-top").addClass("top-nav-collapse") : t(".navbar-fixed-top").removeClass("top-nav-collapse")
        }), t(".navbar-collapse ul li a").click(function() {
            t(".navbar-toggle:visible").click()
        }), t(".nav li a, .logo").on("click", function() {
            var i = t(this).attr("href"),
                n = t(i);
            return e(n, 44), !1
        }), t(function() {
            t('[data-toggle="tooltip"]').tooltip()
        }), t(".screens-carousel").owlCarousel({
            items: 4,
            margin: 30,
            startPosition: 3,
            autoplay: !0,
            autoplayTimeout: 3e3,
            autoplayHoverPause: !0,
            loop: !0,
            nav: !0,
            navText: ['<i class="fa fa-angle-left"></i>', '<i class="fa fa-angle-right"></i>']
        }), t("#testimonials-carousel").owlCarousel({
            items: 1,
            autoplay: !0,
            autoplayTimeout: 3e3,
            autoplayHoverPause: !0,
            loop: !0,
            dots: !0,
            animateOut: "fadeOut"
        }), t("body").append(n()), matchMedia("only screen and (min-width: 768px)").matches && (t(".parallax").jarallax({
            speed: .5,
            imgWidth: 1400,
            imgHeight: 518
        }), t("html, body").animate({
            scrollTop: 2
        }, 1), t(function() {
            t(".element-to-animate").appear(), t(document.body).on("appear", ".element-to-animate", function(e, i) {
                i.each(function() {
                    t(this).removeClass().addClass("animated element-to-animate " + t(this).attr("data-animation-in"))
                })
            })
        })), t(function() {
            t(".progress-bar").appear(), t(document.body).on("appear", ".progress-bar", function(e, i) {
                var n = t(this);
                n.each(function(e) {
                    t(this).css("width", t(this).attr("aria-valuenow") + "%")
                })
            })
        }), t(".lightbox").magnificPopup({
            removalDelay: 300,
            mainClass: "mfp-with-zoom"
        }), t("#mailchimp").ajaxChimp({
            callback: i,
            url: "http://oscodo.us9.list-manage.com/subscribe/post?u=aef5e76b30521b771cf866464&amp;id=f9f9e8db45"
        }), t(document.body).on("click", ".your-skiin", function() {
            var e = t(this).attr("data-path"),
                i = "css/" + e + "/theme.css";
            t("#solo-theme").attr("href", i)
        }), t(".twitter-feed .tweet").twittie({
            dateFormat: "%b. %d, %Y",
            template: '{{tweet}} <div class="date-user"><a href="{{url}}" class="avatar" title="{{user_name}}">{{avatar}}</a> {{date}}</div>',
            count: 1,
            loadingText: "Loading!"
        });
        var s = 300,
            r = 1200,
            a = 700,
            o = t(".go-top");
        t(window).scroll(function() {
            t(this).scrollTop() > s ? o.addClass("cd-is-visible") : o.removeClass("cd-is-visible cd-fade-out"), t(this).scrollTop() > r && o.addClass("cd-fade-out")
        }), o.on("click", function(e) {
            e.preventDefault(), t("body,html").animate({
                scrollTop: 0
            }, a)
        })
    });
