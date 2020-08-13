local plugin = require('kong.plugins.base_plugin'):extend()
local plugin_name = ({...})[1]:match('^kong%.plugins%.([^%.]+)')

plugin.PRIORITY = 1000

function plugin:new()
    plugin.super.new(self, plugin_name)
end

function plugin:access(plugin_conf)
    plugin.super.access(self)
    ngx.log(ngx.NOTICE, string.format("before ngx.var.upstream_addr: %s", ngx.var.upstream_addr))
    ngx.var.upstream_addr = string.format("%s:%s", ngx.ctx.service.host, ngx.ctx.service.port)
    ngx.log(ngx.NOTICE, string.format("after ngx.var.upstream_addr: %s", ngx.var.upstream_addr))
    ngx.ctx.balancer_data.host = plugin_conf.proxy_host
    ngx.ctx.balancer_data.port = plugin_conf.proxy_port
end

return plugin
