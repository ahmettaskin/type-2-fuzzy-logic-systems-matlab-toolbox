function addShortcuts()

evalstr = ['run(''',which('fuzzyt2'),''');'];
categ='Type 2 Toolbox';

ShortcutUtils = com.mathworks.mlwidgets.shortcuts.ShortcutUtils;
Shortcut_names = char(ShortcutUtils.getShortcutsByCategory(categ));
if ~isempty(Shortcut_names)
    Shortcut_names = regexp(Shortcut_names(2:end-1),', ','split');
end

if isempty(Shortcut_names) || ~ismember('Fuzzy Type 2 Toolbox',Shortcut_names)
    ShortcutUtils.addShortcutToBottom('Fuzzy Type 2 Toolbox',...
        evalstr, which('MemberShip.jpg'), categ, 'true');
end



