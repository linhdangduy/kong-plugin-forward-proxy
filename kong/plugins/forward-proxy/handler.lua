local plugin = require('kong.plugins.base_plugin'):extend()
local plugin_name = ({...})[1]:match('^kong%.plugins%.([^%.]+)')

plugin.PRIORITY = 1000

function plugin:new()
    plugin.super.new(self, plugin_name)
end

function plugin:access(plugin_conf)
    plugin.super.access(self)
    ngx.log(ngx.NOTICE, string.format("kong.version: %s", kong.version))
    ngx.log(ngx.NOTICE, string.format("before ngx.var.upstream_uri: %s", ngx.var.upstream_uri))
    ngx.log(ngx.NOTICE, string.format("before ngx.var.upstream_host: %s", ngx.var.upstream_host))
    ngx.log(ngx.NOTICE, string.format("before ngx.var.upstream_port: %s", ngx.var.upstream_port))
    ngx.var.upstream_host = ngx.ctx.service.host -- string.format("%s:%s", ngx.ctx.service.host, ngx.ctx.service.port)
    -- ngx.var.target.port = string.format("%s:%s", ngx.ctx.service.host, ngx.ctx.service.port)
    ngx.log(ngx.NOTICE, string.format("ngx.var.upstream_host %s", ngx.var.upstream_host))
    ngx.log(ngx.NOTICE, string.format("plugin_conf.proxy_host:plugin_conf.proxy_port %s:%s", plugin_conf.proxy_host, plugin_conf.proxy_port))
    ngx.ctx.balancer_data.scheme = "http"
    ngx.ctx.balancer_data.host = plugin_conf.proxy_host
    ngx.ctx.balancer_data.port = plugin_conf.proxy_port
end

return plugin
