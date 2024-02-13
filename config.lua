Config = {}


Config.NearPlayerTime = 500 -- How often (in ms) should the script check for new players in distance
Config.Command = 'users' -- Command name
Config.TextSize = 1.32 -- How big should the text be? (Only works for near players)
Config.DrawDistance = 150 -- How far should players be visible?

-- [Groups that will have access to the command]
Config.AllowedGroups = {
    'owner',
    'moderator',
    -- 'add',
    -- 'more',
    -- 'groups',
    -- 'here',
    'admin',
    'dev'
}