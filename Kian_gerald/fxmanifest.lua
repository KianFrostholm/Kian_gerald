fx_version 'adamant'
game 'gta5'

author 'Kian Frostholm #0001'

description 'Simpelt drug run script med cutscenes fra GTA Online'


shared_script 'config.lua'

client_script {
  'cb/client.lua',
  'client.lua',
}

server_script {
  '@oxmysql/lib/MySQL.lua',
  'cb/server.lua',
  '@vrp/lib/utils.lua',
  'server.lua',
}