prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_220100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.4'
,p_default_workspace_id=>9850767432578500
,p_default_application_id=>144
,p_default_id_offset=>0
,p_default_owner=>'TEST1'
);
end;
/
 
prompt APPLICATION 144 - APEX plugins
--
-- Application Export:
--   Application:     144
--   Name:            APEX plugins
--   Date and Time:   07:17 Thursday September 29, 2022
--   Exported By:     DAVID
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 24181232782723321
--   Manifest End
--   Version:         22.1.4
--   Instance ID:     9750663202120450
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/item_type/glasgow_animated_yes_no_button
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(24181232782723321)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'GLASGOW-ANIMATED-YES-NO-BUTTON'
,p_display_name=>'Pretty check boxes'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--===============================================================================',
'-- Renders the animated yes-no button',
'--',
'-- p_item - the item to be rendered',
'-- p_plugin - contains information about the current plug-in',
'-- p_value - the value of the item which is set here',
'-- p_is_readonly - Is the item rendered readonly',
'-- p_is_printer_friendly - Is the item rendered in printer friendly mode.',
'',
'-- returns apex_plugin.t_page_item_render_result - Result object to be returned',
'',
'--===============================================================================',
'function render (',
'    p_item                in apex_plugin.t_page_item,',
'    p_plugin              in apex_plugin.t_plugin,',
'    p_value               in varchar2,',
'    p_is_readonly         in boolean,',
'    p_is_printer_friendly in boolean )',
'    return apex_plugin.t_page_item_render_result',
'is',
'    -- Use named variables instead of the generic attribute variables',
'    l_checked_value     varchar2(255)  := nvl(p_item.attribute_01, ''Yes'');',
'    l_unchecked_value   varchar2(255)  := p_item.attribute_02;',
'    l_on_colour         varchar2(30)  := nvl(p_item.attribute_03, ''#0084d0'');',
'    l_font_size         number := nvl(p_item.attribute_04, 1);',
'    l_type_of_checkbox  varchar2(255)  := p_item.attribute_08;',
'    l_off_colour        varchar2(30)  := nvl(p_item.attribute_07, ''black'');',
'    l_pretty_on_colour  varchar2(255)  := p_item.attribute_09;',
'',
'    l_name             varchar2(30);',
'    l_value            varchar2(255);',
'    l_checkbox_postfix varchar2(8);',
'    ',
'    v_html             varchar2(4000); -- Used for temp HTML/JS',
'    l_result           apex_plugin.t_page_item_render_result;',
'',
'    ---------------------------------------------------------------------------------------',
'    -- Render the item on the page as an input checkbox, using item name as ID.',
'    --',
'    -- p_css_file_name - name of the css file to load',
'    -- p_outer_div_class_name - clas name for a div that the input checkbox will sit in - empty for none',
'    -- p_label_class_name - class name for the input label - empty for none',
'    -- p_input_class_name - class name for the input - empty for none',
'    -- p_span_html - html to add after the input and within the label - empty for none',
'    ---------------------------------------------------------------------------------------',
'    procedure renderCheckbox(p_css_file_name in varchar2,',
'                                p_outer_div_class_name in varchar2,',
'                                    p_label_class_name in varchar2,',
'                                        p_input_class_name in varchar2,',
'                                            p_span_html in varchar2) is',
'    begin',
'         apex_css.add_file(',
'             p_name      => p_css_file_name,         ',
'             p_directory => p_plugin.file_prefix,',
'             p_version   => null );',
'',
'         sys.htp.prn ( ',
'            ''<div  class="''||p_outer_div_class_name||''">''||',
'                ''<label  class="''||p_label_class_name||''">''||',
'                     ''<input style=" transform: scale(''||l_font_size||'');" class="''||p_input_class_name||''" type="checkbox" id="''||p_item.name||l_checkbox_postfix||''" ''||  '' name="''||l_name||''" ''||',
'                         ''value="''||l_value||''" ''||',
'                            case when l_value = l_checked_value then ''checked="checked" '' end||',
'                            case when p_is_readonly or p_is_printer_friendly then ''disabled="disabled" '' end||',
'                     ''/>'' ||',
'                    p_span_html||',
'                ''</label>',
'            </div>'');',
'    end;',
'',
'    procedure renderPrettyCheckbox(p_css_file_name in varchar2,',
'                                p_outer_div_class_name in varchar2,',
'                                    p_icon_html in varchar2) is',
'    begin',
'         apex_css.add_file(',
'             p_name      => p_css_file_name,         ',
'             p_directory => p_plugin.file_prefix,',
'             p_version   => null );',
'',
'          sys.htp.prn ( ',
'            ''<div style="font-size:''||l_font_size||''em" class="''||p_outer_div_class_name||''">''||',
'                ''<input type="checkbox"  id="''||p_item.name||l_checkbox_postfix||''" ''||  '' name="''||l_name||''" ''||',
'                    ''value="''||l_value||''" ''||',
'                        case when l_value = l_checked_value then ''checked="checked" '' end||',
'                        case when p_is_readonly or p_is_printer_friendly then ''disabled="disabled" '' end||',
'                ''/>'' ||',
'                '' <div class="state ''|| l_pretty_on_colour || ''">',
'                ''||p_icon_html||''',
'            <label></label>',
'        </div>'' ||',
'            ''</div>''); ',
'    end;',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'begin',
'    -- if the current value doesn''t match our checked and unchecked value',
'    -- we fallback to the unchecked value ',
'    if p_value in (l_checked_value, l_unchecked_value) then',
'        l_value := p_value;',
'    else',
'        l_value := l_unchecked_value;',
'    end if;',
'',
'    if p_is_readonly or p_is_printer_friendly then',
'        -- if the checkbox is readonly we will still render a hidden field with',
'        -- the value so that it can be used when the page gets submitted',
'        wwv_flow_plugin_util.print_hidden_if_readonly (',
'            p_item_name           => p_item.name,',
'            p_value               => p_value,',
'            p_is_readonly         => p_is_readonly,',
'            p_is_printer_friendly => p_is_printer_friendly );',
'        l_checkbox_postfix := ''_DISPLAY'';',
'',
'        -- Tell APEX that this field is NOT navigable',
'        l_result.is_navigable := false;',
'    else',
'        -- If a page item saves state, we have to call the get_input_name_for_page_item',
'        -- to render the internal hidden p_arg_names field. It will also return the',
'        -- HTML field name which we have to use when we render the HTML input field.',
'        l_name := wwv_flow_plugin.get_input_name_for_page_item(false);',
'',
'        -- Add the JavaScript library and the call to initialize the checkbox',
'        apex_javascript.add_library (',
'            p_name      => ''glasgow_apex_simple_checkbox'',            ',
'            p_directory => p_plugin.file_prefix,',
'            p_version   => null );',
'',
'        -- this is where we plugin the checkbox code rendered on the page to APEX.',
'        apex_javascript.add_onload_code (',
'            p_code => ''glasgow_simple_checkbox(''||',
'                      apex_javascript.add_value(p_item.name)||',
'                      ''{''||',
'                      apex_javascript.add_attribute(''unchecked'', l_unchecked_value, false)||',
'                      apex_javascript.add_attribute(''checked'',   l_checked_value, false, false)||',
'                      ''});'' );',
'',
'        -- Tell APEX that this field is navigable',
'        l_result.is_navigable := true;',
'    end if;',
'',
'-- render the checkbox depending on type chosen by user.',
'if  l_type_of_checkbox = ''MATERIAL'' then',
'    -- override the css to colour the checkbox on-off state based on the attribute''s the user has set',
'    sys.htp.prn (',
'        ''<head><style>',
'            .material-checkbox:checked:before {',
'                border-color: ''|| l_on_colour || '' !Important;',
'             }',
'        </head></style>'');',
'',
'    renderCheckbox(''material-checkbox'', -- css file name',
'                        '''', -- div class name',
'                            ''label--checkbox'', -- label class name',
'                                ''material-checkbox'', -- input class name',
'                                    ''''); -- span html',
'',
' elsif  l_type_of_checkbox = ''DAT_CHECKBOX'' then',
'   -- override the css to colour the checkbox on-off state based on the attribute''s the user has set',
'    sys.htp.prn (',
'        ''<head><style>',
'            .checkbox__icon:before {',
'            font-size: ''||l_font_size||''em !Important;',
'            }',
'            .checkbox__icon {',
'              color: ''|| l_off_colour || '' !Important;',
'            }',
'            input[type="checkbox"]:checked ~ .checkbox__icon {',
'              color: ''|| l_on_colour || '' !Important;',
'            }',
'        </head></style>'');',
'',
'    renderCheckbox(''dat-checkbox'', -- css file name',
'                        '''', -- div class name',
'                            ''checkbox'', -- label class name',
'                                ''option-input checkbox'', -- input class name',
'                                    ''<span class="checkbox__icon"></span>''); -- span html',
'',
' elsif  l_type_of_checkbox = ''FLUID'' then ',
'    -- override the css to colour the checkbox on-off state based on the attribute''s the user has set',
'    sys.htp.prn (',
'        ''<head><style>',
'            .uiswitch::before {',
'                background-color: ''|| l_off_colour || '' !Important;',
'            }',
'            input:checked + .switcher__indicator::after {',
'              background-color: ''|| l_on_colour || '' !Important;',
'            }',
'            input:checked + .switcher__indicator::before {',
'              background-color: ''|| l_on_colour || '' !Important;',
'            }',
'            .switcher__indicator::after {',
'              background-color: ''|| l_off_colour || '' !Important;',
'            }',
'            .switcher__indicator::before {',
'              background-color: ''|| l_off_colour || '' !Important;',
'            }',
'        </head></style>'');',
'',
'      renderCheckbox(''fluid-checkbox'', -- css file name',
'                        '''', -- div class name',
'                            ''switcher'', -- label class name',
'                                '''', -- input class name',
'                                    ''<div class="switcher__indicator"></div>''); -- span html',
'',
'  elsif  l_type_of_checkbox = ''CLEAN'' then',
'    -- override the css to colour the checkbox on-off state based on the attribute''s the user has set',
'    sys.htp.prn (',
'        ''<head><style>',
'            input[type=checkbox] {',
'                transform: scale(''||l_font_size||'');',
'            }',
'            .uiswitch::before {',
'                background-color: ''|| l_off_colour || '' !Important;',
'            }',
'            .uiswitch:checked {',
'                background-color: ''|| l_on_colour || '' !Important;',
'                background-image: -webkit-linear-gradient(-90deg, ''|| l_on_colour || '' 0%, ''|| l_on_colour || '' 100%)  !Important;',
'                background-image: linear-gradient(-180deg,''|| l_on_colour || '' 0%,''|| l_on_colour || '' 100%  !Important);',
'            }',
'        </head></style>'');',
'',
'    renderCheckbox(''clean'', -- css file name',
'                        '''', -- div class name',
'                            ''fields__item'', -- label class name',
'                                ''uiswitch'', -- input class name',
'                                    ''''); -- span html',
'',
' elsif  l_type_of_checkbox = ''SOFT_TOGGLE'' then',
'    -- override the css to colour the checkbox on-off state based on the attribute''s the user has set',
'    sys.htp.prn (',
'        ''<head><style>',
'            box .check {',
'                border: 2px solid ''|| l_off_colour || '' !Important;',
'                box-shadow: 0px 0px 0px 0px ''|| l_on_colour || '' inset !Important;',
'            }',
'            .box input:checked ~ .check {',
'                border-color: ''|| l_on_colour || '' !Important;',
'                box-shadow: 0px 0px 0px 15px ''|| l_on_colour || '' inset !Important;',
'            }',
'        </head></style>'');',
'',
'    renderCheckbox(''soft-toggle-switch'', -- css file name',
'                        '''', -- div class name',
'                            ''box'', -- label class name',
'                                '''', -- input class name',
'                                    ''<span class="check"></span>''); -- span html',
'',
'elsif  l_type_of_checkbox = ''PRETTY-SLIM-SWITCH'' then',
'',
'  renderPrettyCheckbox(''pretty-checkbox'',',
'                                ''pretty p-switch p-slim'',',
'                                    '''');',
'',
' elsif  l_type_of_checkbox = ''PRETTY'' then  ',
'                                  ',
'  renderPrettyCheckbox(''pretty-checkbox'',',
'                                ''pretty pretty p-icon p-smooth'',',
'                                    ''<i class="icon fa fa-check"></i>'');',
'  ',
' elsif  l_type_of_checkbox = ''PRETTY-JELY'' then  ',
'                                  ',
'  renderPrettyCheckbox(''pretty-checkbox'',',
'                                ''pretty p-icon p-round p-jelly'',',
'                                    ''<i class="icon fa fa-check"></i>'');',
'',
' elsif  l_type_of_checkbox = ''PRETTY-TADA'' then  ',
'                                  ',
'  renderPrettyCheckbox(''pretty-checkbox'',',
'                                ''pretty p-icon p-round p-tada'',',
'                                    ''<i class="icon fa fa-check"></i>'');',
'',
' elsif  l_type_of_checkbox = ''PRETTY-ROTATE'' then  ',
'                                  ',
'  renderPrettyCheckbox(''pretty-checkbox'',',
'                                ''pretty p-icon p-rotate'',',
'                                    ''<i class="icon fa fa-check"></i>'');',
'',
' elsif  l_type_of_checkbox = ''PRETTY-PULSE'' then  ',
'                                  ',
'  renderPrettyCheckbox(''pretty-checkbox'',',
'                                ''pretty p-icon p-round p-pulse'',',
'                                    ''<i class="icon fa fa-check"></i>'');',
'',
'elsif  l_type_of_checkbox = ''PRETTY-SLIM-OUTLINE'' then',
'',
'  renderPrettyCheckbox(''pretty-checkbox'',',
'                                ''pretty p-switch'',',
'                                    '''');',
'',
'elsif  l_type_of_checkbox = ''PRETTY-SLIM-FILL'' then',
'',
'  renderPrettyCheckbox(''pretty-checkbox'',',
'                                ''pretty p-switch p-fill'',',
'                                    '''');',
'',
' elsif  l_type_of_checkbox = ''PRETTY-DEFAULT'' then',
'',
'  renderPrettyCheckbox(''pretty-checkbox'',',
'                                ''pretty p-default'',',
'                                    '''');                                   ',
'',
' elsif  l_type_of_checkbox = ''TOGGLE'' then',
'    apex_css.add_file(',
'             p_name      => ''toggleButton'',         ',
'             p_directory => p_plugin.file_prefix,',
'             p_version   => null );',
'',
'        sys.htp.prn (',
'        ''<head><style>',
'            .toggleButton input + div {',
'  border: 3px solid ''|| l_on_colour || '' !Important;',
'}',
'',
'.toggleButton input + div:before, .toggleButton input + div:after {',
'  background: ''|| l_oFF_colour || '' !Important;',
'}',
'        </head></style>'');',
'           ',
'         -- different to the other types of checkboxes so dont use function for this one.',
'         sys.htp.prn ( ',
'            ''<label class="toggleButton">''||',
'                ''<input type="checkbox"  id="''||p_item.name||l_checkbox_postfix||''" ''||  '' name="''||l_name||''" ''||',
'                    ''value="''||l_value||''" ''||',
'                        case when l_value = l_checked_value then ''checked="checked" '' end||',
'                        case when p_is_readonly or p_is_printer_friendly then ''disabled="disabled" '' end||',
'                ''/>'' ||',
'                ''<div>',
'        <svg viewBox="0 0 44 44">',
'            <path d="M14,24 L21,31 L39.7428882,11.5937758 C35.2809627,6.53125861 30.0333333,4 24,4 C12.95,4 4,12.95 4,24 C4,35.05 12.95,44 24,44 C35.05,44 44,35.05 44,24 C44,19.3 42.5809627,15.1645919 39.7428882,11.5937758" transform="translate(-2.00'
||'0000, -2.000000)"></path>',
'        </svg>',
'    </div>'' ||',
'            ''</label>''); ',
'',
'',
'  elsif l_type_of_checkbox = ''ANIMATED_BUTTON'' then',
'',
'        apex_css.add_file(',
'             p_name      => ''animatedButton'',         ',
'             p_directory => p_plugin.file_prefix,',
'             p_version   => null );',
'',
'        sys.htp.prn (',
'            ''<head><style>',
'',
'                .switch-right {',
'                    background-color: ''|| l_off_colour || '' !Important;',
'                }',
'',
'                input:checked + .switch-left {',
'                    background-color: ''|| l_on_colour || '' !Important;',
'                }',
'            </head></style>'');',
'           ',
'         -- different to the other types of checkboxes so dont use function for this one.',
'         sys.htp.prn ( ''<div class="mid">'' ||',
'            ''<label style="font-size: ''||l_font_size||''em !Important;"  class="rocker">''||',
'                ''<input type="checkbox" style="display: none;" id="''||p_item.name||l_checkbox_postfix||''" ''||  '' name="''||l_name||''" ''||',
'                    ''value="''||l_value||''" ''||',
'                        case when l_value = l_checked_value then ''checked="checked" '' end||',
'                        case when p_is_readonly or p_is_printer_friendly then ''disabled="disabled" '' end||',
'                ''/>'' ||',
'                ''<span class="switch-left">''||l_checked_value||''</span>''||',
'                ''<span class="switch-right">''||l_unchecked_value||''</span>''||   ',
'            ''</label>''||',
'        ''</div>''); ',
'',
' end if;',
'',
' return l_result;',
'end render;',
'',
'',
''))
,p_api_version=>1
,p_render_function=>'render'
,p_standard_attributes=>'VISIBLE:SESSION_STATE:READONLY:SOURCE:ELEMENT:ENCRYPT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'This item type plug-in displays an item as a checkbox but allows you to set 2 values (one for checked and another for unchecked). checkboxes.</p>',
'It also allows you to change size and colour of the checkbox, currently there are 16 different types of checkboxes to choose from.'))
,p_version_identifier=>'1.3'
,p_about_url=>'https://kjwvivmv0n5reuj-apexkqor.adb.uk-london-1.oraclecloudapps.com/ords/r/test1/apex-plugins/on-off-animtaed-button'
,p_files_version=>251
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(24181424713723337)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Checked Value'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Y'
,p_display_length=>10
,p_max_length=>255
,p_is_translatable=>false
,p_help_text=>'Value stored if the checkbox is checked.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(24181850309723339)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Unchecked Value'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_display_length=>10
,p_max_length=>255
,p_is_translatable=>false
,p_help_text=>'Value stored if the checkbox is un-checked.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(24256237861620337)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'On colour'
,p_attribute_type=>'COLOR'
,p_is_required=>false
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_help_text=>'Colour of on.  Default is #0084d0. Please note this does not affect the pretty checkboxes use Pretty on-colour instead.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(24265515792687806)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Size'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_unit=>'em'
,p_is_translatable=>false
,p_help_text=>'The size of the checkbox'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(26440979780546882)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>35
,p_prompt=>'Off colour'
,p_attribute_type=>'COLOR'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'The off colour.  Please note this does not affect the pretty checkboxes which default to grey'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(26541345000838539)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>1
,p_prompt=>'Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'DAT_CHECKBOX'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Choose the type of checkbox you want to display'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26542517072840679)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>10
,p_display_value=>'Animated Button'
,p_return_value=>'ANIMATED_BUTTON'
,p_is_quick_pick=>true
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26542934215842586)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>20
,p_display_value=>'Soft toggle switch'
,p_return_value=>'SOFT_TOGGLE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26543396145843905)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>30
,p_display_value=>'Material'
,p_return_value=>'MATERIAL'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26543780871845707)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>40
,p_display_value=>'Dat checkbox'
,p_return_value=>'DAT_CHECKBOX'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26547747695884954)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>50
,p_display_value=>'Fluid'
,p_return_value=>'FLUID'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26552998872866559)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>60
,p_display_value=>'Clean'
,p_return_value=>'CLEAN'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26653304688137118)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>70
,p_display_value=>'toggle'
,p_return_value=>'TOGGLE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26716517391200489)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>80
,p_display_value=>'Pretty'
,p_return_value=>'PRETTY'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26902074783747873)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>90
,p_display_value=>'Pretty-slim-switch'
,p_return_value=>'PRETTY-SLIM-SWITCH'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26928020968842671)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>100
,p_display_value=>'Pretty-jely'
,p_return_value=>'PRETTY-JELY'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26933877504876494)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>110
,p_display_value=>'Pretty-tada'
,p_return_value=>'PRETTY-TADA'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26940232408901425)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>120
,p_display_value=>'Pretty-pulse'
,p_return_value=>'PRETTY-PULSE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26940663996903361)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>130
,p_display_value=>'Pretty-rotate'
,p_return_value=>'PRETTY-ROTATE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26950398127998722)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>140
,p_display_value=>'Pretty-slim-outline'
,p_return_value=>'PRETTY-SLIM-OUTLINE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26950788226001110)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>150
,p_display_value=>'Pretty-slim-fill'
,p_return_value=>'PRETTY-SLIM-FILL'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26951143609002853)
,p_plugin_attribute_id=>wwv_flow_imp.id(26541345000838539)
,p_display_sequence=>160
,p_display_value=>'Pretty-default'
,p_return_value=>'PRETTY-DEFAULT'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(26913251100796088)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Pretty on-colour'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'Primary'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'This is for the on colour of the pretty checkboxes only.  For the other checkboxes use on/off colour attributes'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26915968269797364)
,p_plugin_attribute_id=>wwv_flow_imp.id(26913251100796088)
,p_display_sequence=>10
,p_display_value=>'Success'
,p_return_value=>'p-success'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26918651145799250)
,p_plugin_attribute_id=>wwv_flow_imp.id(26913251100796088)
,p_display_sequence=>20
,p_display_value=>'Primary'
,p_return_value=>'p-primary'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26919025477800967)
,p_plugin_attribute_id=>wwv_flow_imp.id(26913251100796088)
,p_display_sequence=>30
,p_display_value=>'Info'
,p_return_value=>'p-info'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26919443777802348)
,p_plugin_attribute_id=>wwv_flow_imp.id(26913251100796088)
,p_display_sequence=>40
,p_display_value=>'Warning'
,p_return_value=>'p-warning'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(26919855517803870)
,p_plugin_attribute_id=>wwv_flow_imp.id(26913251100796088)
,p_display_sequence=>50
,p_display_value=>'Danger'
,p_return_value=>'p-danger'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(24194703988723361)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_name=>'switchchange'
,p_display_name=>'Switch Changed'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '66756E6374696F6E20636F6D5F6F7261636C655F617065785F73696D706C655F636865636B626F7828652C206329207B0D0A202020207661722062203D20617065782E6A517565727928222E22202B2065290D0A2020202020202C2061203D2061706578';
wwv_flow_imp.g_varchar2_table(2) := '2E6A517565727928222322202B2065202B20225F48494444454E22293B0D0A202020202020616C6572742861293B0D0A202020202020636F6E736F6C652E6C6F67287B627D293B0D0A2020202066756E6374696F6E20642829207B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(3) := '20612E76616C2828622E697328223A636865636B65642229203D3D3D207472756529203F20632E636865636B6564203A20632E756E636865636B6564290D0A202020207D0D0A20202020617065782E6A517565727928222E22202B2065292E6368616E67';
wwv_flow_imp.g_varchar2_table(4) := '652864293B0D0A20202020617065782E6A517565727928646F63756D656E74292E62696E642822617065786265666F7265706167657375626D6974222C2064293B0D0A20202020617065782E7769646765742E696E6974506167654974656D28652C207B';
wwv_flow_imp.g_varchar2_table(5) := '0D0A202020202020202073657456616C75653A2066756E6374696F6E286629207B0D0A202020202020202020202020622E617474722822636865636B6564222C202866203D3D3D20632E636865636B656429293B0D0A2020202020202020202020206428';
wwv_flow_imp.g_varchar2_table(6) := '290D0A20202020202020207D2C0D0A202020202020202067657456616C75653A2066756E6374696F6E2829207B0D0A20202020202020202020202072657475726E20612E76616C28290D0A20202020202020207D0D0A202020207D290D0A7D0D0A3B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(24225900378033748)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'com_oracle_apex_simple_checkbox.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0A202A20626F6F7473747261702D737769746368202D207633';
wwv_flow_imp.g_varchar2_table(2) := '2E332E320A202A20687474703A2F2F7777772E626F6F7473747261702D7377697463682E6F72670A202A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(3) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0A202A20436F7079726967687420323031322D32303133204D6174746961204C6172656E7469730A202A0A202A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(4) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0A202A204C6963656E73656420756E6465722074686520417061636865204C6963656E73652C2056657273696F6E20322E30202874686520224C6963656E736522293B';
wwv_flow_imp.g_varchar2_table(5) := '0A202A20796F75206D6179206E6F742075736520746869732066696C652065786365707420696E20636F6D706C69616E6365207769746820746865204C6963656E73652E0A202A20596F75206D6179206F627461696E206120636F7079206F6620746865';
wwv_flow_imp.g_varchar2_table(6) := '204C6963656E73652061740A202A0A202A2020202020687474703A2F2F7777772E6170616368652E6F72672F6C6963656E7365732F4C4943454E53452D322E300A202A0A202A20556E6C657373207265717569726564206279206170706C696361626C65';
wwv_flow_imp.g_varchar2_table(7) := '206C6177206F722061677265656420746F20696E2077726974696E672C20736F6674776172650A202A20646973747269627574656420756E64657220746865204C6963656E7365206973206469737472696275746564206F6E20616E2022415320495322';
wwv_flow_imp.g_varchar2_table(8) := '2042415349532C0A202A20574954484F55542057415252414E54494553204F5220434F4E444954494F4E53204F4620414E59204B494E442C206569746865722065787072657373206F7220696D706C6965642E0A202A2053656520746865204C6963656E';
wwv_flow_imp.g_varchar2_table(9) := '736520666F7220746865207370656369666963206C616E677561676520676F7665726E696E67207065726D697373696F6E7320616E640A202A206C696D69746174696F6E7320756E64657220746865204C6963656E73652E0A202A203D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(10) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0A202A2F0A0A2866756E6374696F6E28297B76617220743D5B5D2E736C6963653B216675';
wwv_flow_imp.g_varchar2_table(11) := '6E6374696F6E28652C69297B2275736520737472696374223B766172206E3B72657475726E206E3D66756E6374696F6E28297B66756E6374696F6E207428742C69297B6E756C6C3D3D69262628693D7B7D292C746869732E24656C656D656E743D652874';
wwv_flow_imp.g_varchar2_table(12) := '292C746869732E6F7074696F6E733D652E657874656E64287B7D2C652E666E2E626F6F7473747261705377697463682E64656661756C74732C7B73746174653A746869732E24656C656D656E742E697328223A636865636B656422292C73697A653A7468';
wwv_flow_imp.g_varchar2_table(13) := '69732E24656C656D656E742E64617461282273697A6522292C616E696D6174653A746869732E24656C656D656E742E646174612822616E696D61746522292C64697361626C65643A746869732E24656C656D656E742E697328223A64697361626C656422';
wwv_flow_imp.g_varchar2_table(14) := '292C726561646F6E6C793A746869732E24656C656D656E742E697328225B726561646F6E6C795D22292C696E64657465726D696E6174653A746869732E24656C656D656E742E646174612822696E64657465726D696E61746522292C696E76657273653A';
wwv_flow_imp.g_varchar2_table(15) := '746869732E24656C656D656E742E646174612822696E766572736522292C726164696F416C6C4F66663A746869732E24656C656D656E742E646174612822726164696F2D616C6C2D6F666622292C6F6E436F6C6F723A746869732E24656C656D656E742E';
wwv_flow_imp.g_varchar2_table(16) := '6461746128226F6E2D636F6C6F7222292C6F6666436F6C6F723A746869732E24656C656D656E742E6461746128226F66662D636F6C6F7222292C6F6E546578743A746869732E24656C656D656E742E6461746128226F6E2D7465787422292C6F66665465';
wwv_flow_imp.g_varchar2_table(17) := '78743A746869732E24656C656D656E742E6461746128226F66662D7465787422292C6C6162656C546578743A746869732E24656C656D656E742E6461746128226C6162656C2D7465787422292C68616E646C6557696474683A746869732E24656C656D65';
wwv_flow_imp.g_varchar2_table(18) := '6E742E64617461282268616E646C652D776964746822292C6C6162656C57696474683A746869732E24656C656D656E742E6461746128226C6162656C2D776964746822292C62617365436C6173733A746869732E24656C656D656E742E64617461282262';
wwv_flow_imp.g_varchar2_table(19) := '6173652D636C61737322292C77726170706572436C6173733A746869732E24656C656D656E742E646174612822777261707065722D636C61737322297D2C69292C746869732E707265764F7074696F6E733D7B7D2C746869732E24777261707065723D65';
wwv_flow_imp.g_varchar2_table(20) := '28223C6469763E222C7B22636C617373223A66756E6374696F6E2874297B72657475726E2066756E6374696F6E28297B76617220653B72657475726E20653D5B22222B742E6F7074696F6E732E62617365436C6173735D2E636F6E63617428742E5F6765';
wwv_flow_imp.g_varchar2_table(21) := '74436C617373657328742E6F7074696F6E732E77726170706572436C61737329292C652E7075736828742E6F7074696F6E732E73746174653F742E6F7074696F6E732E62617365436C6173732B222D6F6E223A742E6F7074696F6E732E62617365436C61';
wwv_flow_imp.g_varchar2_table(22) := '73732B222D6F666622292C6E756C6C213D742E6F7074696F6E732E73697A652626652E7075736828742E6F7074696F6E732E62617365436C6173732B222D222B742E6F7074696F6E732E73697A65292C742E6F7074696F6E732E64697361626C65642626';
wwv_flow_imp.g_varchar2_table(23) := '652E7075736828742E6F7074696F6E732E62617365436C6173732B222D64697361626C656422292C742E6F7074696F6E732E726561646F6E6C792626652E7075736828742E6F7074696F6E732E62617365436C6173732B222D726561646F6E6C7922292C';
wwv_flow_imp.g_varchar2_table(24) := '742E6F7074696F6E732E696E64657465726D696E6174652626652E7075736828742E6F7074696F6E732E62617365436C6173732B222D696E64657465726D696E61746522292C742E6F7074696F6E732E696E76657273652626652E7075736828742E6F70';
wwv_flow_imp.g_varchar2_table(25) := '74696F6E732E62617365436C6173732B222D696E766572736522292C742E24656C656D656E742E617474722822696422292626652E7075736828742E6F7074696F6E732E62617365436C6173732B222D69642D222B742E24656C656D656E742E61747472';
wwv_flow_imp.g_varchar2_table(26) := '282269642229292C652E6A6F696E28222022297D7D28746869732928297D292C746869732E24636F6E7461696E65723D6528223C6469763E222C7B22636C617373223A746869732E6F7074696F6E732E62617365436C6173732B222D636F6E7461696E65';
wwv_flow_imp.g_varchar2_table(27) := '72227D292C746869732E246F6E3D6528223C7370616E3E222C7B68746D6C3A746869732E6F7074696F6E732E6F6E546578742C22636C617373223A746869732E6F7074696F6E732E62617365436C6173732B222D68616E646C652D6F6E20222B74686973';
wwv_flow_imp.g_varchar2_table(28) := '2E6F7074696F6E732E62617365436C6173732B222D222B746869732E6F7074696F6E732E6F6E436F6C6F727D292C746869732E246F66663D6528223C7370616E3E222C7B68746D6C3A746869732E6F7074696F6E732E6F6666546578742C22636C617373';
wwv_flow_imp.g_varchar2_table(29) := '223A746869732E6F7074696F6E732E62617365436C6173732B222D68616E646C652D6F666620222B746869732E6F7074696F6E732E62617365436C6173732B222D222B746869732E6F7074696F6E732E6F6666436F6C6F727D292C746869732E246C6162';
wwv_flow_imp.g_varchar2_table(30) := '656C3D6528223C7370616E3E222C7B68746D6C3A746869732E6F7074696F6E732E6C6162656C546578742C22636C617373223A746869732E6F7074696F6E732E62617365436C6173732B222D6C6162656C227D292C746869732E24656C656D656E742E6F';
wwv_flow_imp.g_varchar2_table(31) := '6E2822696E69742E626F6F747374726170537769746368222C66756E6374696F6E2865297B72657475726E2066756E6374696F6E28297B72657475726E20652E6F7074696F6E732E6F6E496E69742E6170706C7928742C617267756D656E7473297D7D28';
wwv_flow_imp.g_varchar2_table(32) := '7468697329292C746869732E24656C656D656E742E6F6E28227377697463684368616E67652E626F6F747374726170537769746368222C66756E6374696F6E2869297B72657475726E2066756E6374696F6E286E297B72657475726E21313D3D3D692E6F';
wwv_flow_imp.g_varchar2_table(33) := '7074696F6E732E6F6E5377697463684368616E67652E6170706C7928742C617267756D656E7473293F692E24656C656D656E742E697328223A726164696F22293F6528225B6E616D653D27222B692E24656C656D656E742E6174747228226E616D652229';
wwv_flow_imp.g_varchar2_table(34) := '2B22275D22292E74726967676572282270726576696F757353746174652E626F6F747374726170537769746368222C2130293A692E24656C656D656E742E74726967676572282270726576696F757353746174652E626F6F747374726170537769746368';
wwv_flow_imp.g_varchar2_table(35) := '222C2130293A766F696420307D7D287468697329292C746869732E24636F6E7461696E65723D746869732E24656C656D656E742E7772617028746869732E24636F6E7461696E6572292E706172656E7428292C746869732E24777261707065723D746869';
wwv_flow_imp.g_varchar2_table(36) := '732E24636F6E7461696E65722E7772617028746869732E2477726170706572292E706172656E7428292C746869732E24656C656D656E742E6265666F726528746869732E6F7074696F6E732E696E76657273653F746869732E246F66663A746869732E24';
wwv_flow_imp.g_varchar2_table(37) := '6F6E292E6265666F726528746869732E246C6162656C292E6265666F726528746869732E6F7074696F6E732E696E76657273653F746869732E246F6E3A746869732E246F6666292C746869732E6F7074696F6E732E696E64657465726D696E6174652626';
wwv_flow_imp.g_varchar2_table(38) := '746869732E24656C656D656E742E70726F702822696E64657465726D696E617465222C2130292C746869732E5F696E697428292C746869732E5F656C656D656E7448616E646C65727328292C746869732E5F68616E646C6548616E646C65727328292C74';
wwv_flow_imp.g_varchar2_table(39) := '6869732E5F6C6162656C48616E646C65727328292C746869732E5F666F726D48616E646C657228292C746869732E5F65787465726E616C4C6162656C48616E646C657228292C746869732E24656C656D656E742E747269676765722822696E69742E626F';
wwv_flow_imp.g_varchar2_table(40) := '6F747374726170537769746368222C746869732E6F7074696F6E732E7374617465297D72657475726E20742E70726F746F747970652E5F636F6E7374727563746F723D742C742E70726F746F747970652E736574507265764F7074696F6E733D66756E63';
wwv_flow_imp.g_varchar2_table(41) := '74696F6E28297B72657475726E20746869732E707265764F7074696F6E733D652E657874656E642821302C7B7D2C746869732E6F7074696F6E73297D2C742E70726F746F747970652E73746174653D66756E6374696F6E28742C69297B72657475726E22';
wwv_flow_imp.g_varchar2_table(42) := '756E646566696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E73746174653A746869732E6F7074696F6E732E64697361626C65647C7C746869732E6F7074696F6E732E726561646F6E6C793F746869732E24656C656D656E743A74';
wwv_flow_imp.g_varchar2_table(43) := '6869732E6F7074696F6E732E7374617465262621746869732E6F7074696F6E732E726164696F416C6C4F66662626746869732E24656C656D656E742E697328223A726164696F22293F746869732E24656C656D656E743A28746869732E24656C656D656E';
wwv_flow_imp.g_varchar2_table(44) := '742E697328223A726164696F22293F6528225B6E616D653D27222B746869732E24656C656D656E742E6174747228226E616D6522292B22275D22292E74726967676572282273657450726576696F75734F7074696F6E732E626F6F747374726170537769';
wwv_flow_imp.g_varchar2_table(45) := '74636822293A746869732E24656C656D656E742E74726967676572282273657450726576696F75734F7074696F6E732E626F6F74737472617053776974636822292C746869732E6F7074696F6E732E696E64657465726D696E6174652626746869732E69';
wwv_flow_imp.g_varchar2_table(46) := '6E64657465726D696E617465282131292C743D2121742C746869732E24656C656D656E742E70726F702822636865636B6564222C74292E7472696767657228226368616E67652E626F6F747374726170537769746368222C69292C746869732E24656C65';
wwv_flow_imp.g_varchar2_table(47) := '6D656E74297D2C742E70726F746F747970652E746F67676C6553746174653D66756E6374696F6E2874297B72657475726E20746869732E6F7074696F6E732E64697361626C65647C7C746869732E6F7074696F6E732E726561646F6E6C793F746869732E';
wwv_flow_imp.g_varchar2_table(48) := '24656C656D656E743A746869732E6F7074696F6E732E696E64657465726D696E6174653F28746869732E696E64657465726D696E617465282131292C746869732E737461746528213029293A746869732E24656C656D656E742E70726F70282263686563';
wwv_flow_imp.g_varchar2_table(49) := '6B6564222C21746869732E6F7074696F6E732E7374617465292E7472696767657228226368616E67652E626F6F747374726170537769746368222C74297D2C742E70726F746F747970652E73697A653D66756E6374696F6E2874297B72657475726E2275';
wwv_flow_imp.g_varchar2_table(50) := '6E646566696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E73697A653A286E756C6C213D746869732E6F7074696F6E732E73697A652626746869732E24777261707065722E72656D6F7665436C61737328746869732E6F7074696F';
wwv_flow_imp.g_varchar2_table(51) := '6E732E62617365436C6173732B222D222B746869732E6F7074696F6E732E73697A65292C742626746869732E24777261707065722E616464436C61737328746869732E6F7074696F6E732E62617365436C6173732B222D222B74292C746869732E5F7769';
wwv_flow_imp.g_varchar2_table(52) := '64746828292C746869732E5F636F6E7461696E6572506F736974696F6E28292C746869732E6F7074696F6E732E73697A653D742C746869732E24656C656D656E74297D2C742E70726F746F747970652E616E696D6174653D66756E6374696F6E2874297B';
wwv_flow_imp.g_varchar2_table(53) := '72657475726E22756E646566696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E616E696D6174653A28743D2121742C743D3D3D746869732E6F7074696F6E732E616E696D6174653F746869732E24656C656D656E743A746869732E';
wwv_flow_imp.g_varchar2_table(54) := '746F67676C65416E696D6174652829297D2C742E70726F746F747970652E746F67676C65416E696D6174653D66756E6374696F6E28297B72657475726E20746869732E6F7074696F6E732E616E696D6174653D21746869732E6F7074696F6E732E616E69';
wwv_flow_imp.g_varchar2_table(55) := '6D6174652C746869732E24777261707065722E746F67676C65436C61737328746869732E6F7074696F6E732E62617365436C6173732B222D616E696D61746522292C746869732E24656C656D656E747D2C742E70726F746F747970652E64697361626C65';
wwv_flow_imp.g_varchar2_table(56) := '643D66756E6374696F6E2874297B72657475726E22756E646566696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E64697361626C65643A28743D2121742C743D3D3D746869732E6F7074696F6E732E64697361626C65643F746869';
wwv_flow_imp.g_varchar2_table(57) := '732E24656C656D656E743A746869732E746F67676C6544697361626C65642829297D2C742E70726F746F747970652E746F67676C6544697361626C65643D66756E6374696F6E28297B72657475726E20746869732E6F7074696F6E732E64697361626C65';
wwv_flow_imp.g_varchar2_table(58) := '643D21746869732E6F7074696F6E732E64697361626C65642C746869732E24656C656D656E742E70726F70282264697361626C6564222C746869732E6F7074696F6E732E64697361626C6564292C746869732E24777261707065722E746F67676C65436C';
wwv_flow_imp.g_varchar2_table(59) := '61737328746869732E6F7074696F6E732E62617365436C6173732B222D64697361626C656422292C746869732E24656C656D656E747D2C742E70726F746F747970652E726561646F6E6C793D66756E6374696F6E2874297B72657475726E22756E646566';
wwv_flow_imp.g_varchar2_table(60) := '696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E726561646F6E6C793A28743D2121742C743D3D3D746869732E6F7074696F6E732E726561646F6E6C793F746869732E24656C656D656E743A746869732E746F67676C6552656164';
wwv_flow_imp.g_varchar2_table(61) := '6F6E6C792829297D2C742E70726F746F747970652E746F67676C65526561646F6E6C793D66756E6374696F6E28297B72657475726E20746869732E6F7074696F6E732E726561646F6E6C793D21746869732E6F7074696F6E732E726561646F6E6C792C74';
wwv_flow_imp.g_varchar2_table(62) := '6869732E24656C656D656E742E70726F702822726561646F6E6C79222C746869732E6F7074696F6E732E726561646F6E6C79292C746869732E24777261707065722E746F67676C65436C61737328746869732E6F7074696F6E732E62617365436C617373';
wwv_flow_imp.g_varchar2_table(63) := '2B222D726561646F6E6C7922292C746869732E24656C656D656E747D2C742E70726F746F747970652E696E64657465726D696E6174653D66756E6374696F6E2874297B72657475726E22756E646566696E6564223D3D747970656F6620743F746869732E';
wwv_flow_imp.g_varchar2_table(64) := '6F7074696F6E732E696E64657465726D696E6174653A28743D2121742C743D3D3D746869732E6F7074696F6E732E696E64657465726D696E6174653F746869732E24656C656D656E743A746869732E746F67676C65496E64657465726D696E6174652829';
wwv_flow_imp.g_varchar2_table(65) := '297D2C742E70726F746F747970652E746F67676C65496E64657465726D696E6174653D66756E6374696F6E28297B72657475726E20746869732E6F7074696F6E732E696E64657465726D696E6174653D21746869732E6F7074696F6E732E696E64657465';
wwv_flow_imp.g_varchar2_table(66) := '726D696E6174652C746869732E24656C656D656E742E70726F702822696E64657465726D696E617465222C746869732E6F7074696F6E732E696E64657465726D696E617465292C746869732E24777261707065722E746F67676C65436C61737328746869';
wwv_flow_imp.g_varchar2_table(67) := '732E6F7074696F6E732E62617365436C6173732B222D696E64657465726D696E61746522292C746869732E5F636F6E7461696E6572506F736974696F6E28292C746869732E24656C656D656E747D2C742E70726F746F747970652E696E76657273653D66';
wwv_flow_imp.g_varchar2_table(68) := '756E6374696F6E2874297B72657475726E22756E646566696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E696E76657273653A28743D2121742C743D3D3D746869732E6F7074696F6E732E696E76657273653F746869732E24656C';
wwv_flow_imp.g_varchar2_table(69) := '656D656E743A746869732E746F67676C65496E76657273652829297D2C742E70726F746F747970652E746F67676C65496E76657273653D66756E6374696F6E28297B76617220742C653B72657475726E20746869732E24777261707065722E746F67676C';
wwv_flow_imp.g_varchar2_table(70) := '65436C61737328746869732E6F7074696F6E732E62617365436C6173732B222D696E766572736522292C653D746869732E246F6E2E636C6F6E65282130292C743D746869732E246F66662E636C6F6E65282130292C746869732E246F6E2E7265706C6163';
wwv_flow_imp.g_varchar2_table(71) := '65576974682874292C746869732E246F66662E7265706C616365576974682865292C746869732E246F6E3D742C746869732E246F66663D652C746869732E6F7074696F6E732E696E76657273653D21746869732E6F7074696F6E732E696E76657273652C';
wwv_flow_imp.g_varchar2_table(72) := '746869732E24656C656D656E747D2C742E70726F746F747970652E6F6E436F6C6F723D66756E6374696F6E2874297B76617220653B72657475726E20653D746869732E6F7074696F6E732E6F6E436F6C6F722C22756E646566696E6564223D3D74797065';
wwv_flow_imp.g_varchar2_table(73) := '6F6620743F653A286E756C6C213D652626746869732E246F6E2E72656D6F7665436C61737328746869732E6F7074696F6E732E62617365436C6173732B222D222B65292C746869732E246F6E2E616464436C61737328746869732E6F7074696F6E732E62';
wwv_flow_imp.g_varchar2_table(74) := '617365436C6173732B222D222B74292C746869732E6F7074696F6E732E6F6E436F6C6F723D742C746869732E24656C656D656E74297D2C742E70726F746F747970652E6F6666436F6C6F723D66756E6374696F6E2874297B76617220653B72657475726E';
wwv_flow_imp.g_varchar2_table(75) := '20653D746869732E6F7074696F6E732E6F6666436F6C6F722C22756E646566696E6564223D3D747970656F6620743F653A286E756C6C213D652626746869732E246F66662E72656D6F7665436C61737328746869732E6F7074696F6E732E62617365436C';
wwv_flow_imp.g_varchar2_table(76) := '6173732B222D222B65292C746869732E246F66662E616464436C61737328746869732E6F7074696F6E732E62617365436C6173732B222D222B74292C746869732E6F7074696F6E732E6F6666436F6C6F723D742C746869732E24656C656D656E74297D2C';
wwv_flow_imp.g_varchar2_table(77) := '742E70726F746F747970652E6F6E546578743D66756E6374696F6E2874297B72657475726E22756E646566696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E6F6E546578743A28746869732E246F6E2E68746D6C2874292C746869';
wwv_flow_imp.g_varchar2_table(78) := '732E5F776964746828292C746869732E5F636F6E7461696E6572506F736974696F6E28292C746869732E6F7074696F6E732E6F6E546578743D742C746869732E24656C656D656E74297D2C742E70726F746F747970652E6F6666546578743D66756E6374';
wwv_flow_imp.g_varchar2_table(79) := '696F6E2874297B72657475726E22756E646566696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E6F6666546578743A28746869732E246F66662E68746D6C2874292C746869732E5F776964746828292C746869732E5F636F6E7461';
wwv_flow_imp.g_varchar2_table(80) := '696E6572506F736974696F6E28292C746869732E6F7074696F6E732E6F6666546578743D742C746869732E24656C656D656E74297D2C742E70726F746F747970652E6C6162656C546578743D66756E6374696F6E2874297B72657475726E22756E646566';
wwv_flow_imp.g_varchar2_table(81) := '696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E6C6162656C546578743A28746869732E246C6162656C2E68746D6C2874292C746869732E5F776964746828292C746869732E6F7074696F6E732E6C6162656C546578743D742C74';
wwv_flow_imp.g_varchar2_table(82) := '6869732E24656C656D656E74297D2C742E70726F746F747970652E68616E646C6557696474683D66756E6374696F6E2874297B72657475726E22756E646566696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E68616E646C655769';
wwv_flow_imp.g_varchar2_table(83) := '6474683A28746869732E6F7074696F6E732E68616E646C6557696474683D742C746869732E5F776964746828292C746869732E5F636F6E7461696E6572506F736974696F6E28292C746869732E24656C656D656E74297D2C742E70726F746F747970652E';
wwv_flow_imp.g_varchar2_table(84) := '6C6162656C57696474683D66756E6374696F6E2874297B72657475726E22756E646566696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E6C6162656C57696474683A28746869732E6F7074696F6E732E6C6162656C57696474683D';
wwv_flow_imp.g_varchar2_table(85) := '742C746869732E5F776964746828292C746869732E5F636F6E7461696E6572506F736974696F6E28292C746869732E24656C656D656E74297D2C742E70726F746F747970652E62617365436C6173733D66756E6374696F6E2874297B72657475726E2074';
wwv_flow_imp.g_varchar2_table(86) := '6869732E6F7074696F6E732E62617365436C6173737D2C742E70726F746F747970652E77726170706572436C6173733D66756E6374696F6E2874297B72657475726E22756E646566696E6564223D3D747970656F6620743F746869732E6F7074696F6E73';
wwv_flow_imp.g_varchar2_table(87) := '2E77726170706572436C6173733A28747C7C28743D652E666E2E626F6F7473747261705377697463682E64656661756C74732E77726170706572436C617373292C746869732E24777261707065722E72656D6F7665436C61737328746869732E5F676574';
wwv_flow_imp.g_varchar2_table(88) := '436C617373657328746869732E6F7074696F6E732E77726170706572436C617373292E6A6F696E2822202229292C746869732E24777261707065722E616464436C61737328746869732E5F676574436C61737365732874292E6A6F696E2822202229292C';
wwv_flow_imp.g_varchar2_table(89) := '746869732E6F7074696F6E732E77726170706572436C6173733D742C746869732E24656C656D656E74297D2C742E70726F746F747970652E726164696F416C6C4F66663D66756E6374696F6E2874297B72657475726E22756E646566696E6564223D3D74';
wwv_flow_imp.g_varchar2_table(90) := '7970656F6620743F746869732E6F7074696F6E732E726164696F416C6C4F66663A28743D2121742C743D3D3D746869732E6F7074696F6E732E726164696F416C6C4F66663F746869732E24656C656D656E743A28746869732E6F7074696F6E732E726164';
wwv_flow_imp.g_varchar2_table(91) := '696F416C6C4F66663D742C746869732E24656C656D656E7429297D2C742E70726F746F747970652E6F6E496E69743D66756E6374696F6E2874297B72657475726E22756E646566696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E';
wwv_flow_imp.g_varchar2_table(92) := '6F6E496E69743A28747C7C28743D652E666E2E626F6F7473747261705377697463682E64656661756C74732E6F6E496E6974292C746869732E6F7074696F6E732E6F6E496E69743D742C746869732E24656C656D656E74297D2C742E70726F746F747970';
wwv_flow_imp.g_varchar2_table(93) := '652E6F6E5377697463684368616E67653D66756E6374696F6E2874297B72657475726E22756E646566696E6564223D3D747970656F6620743F746869732E6F7074696F6E732E6F6E5377697463684368616E67653A28747C7C28743D652E666E2E626F6F';
wwv_flow_imp.g_varchar2_table(94) := '7473747261705377697463682E64656661756C74732E6F6E5377697463684368616E6765292C746869732E6F7074696F6E732E6F6E5377697463684368616E67653D742C746869732E24656C656D656E74297D2C742E70726F746F747970652E64657374';
wwv_flow_imp.g_varchar2_table(95) := '726F793D66756E6374696F6E28297B76617220743B72657475726E20743D746869732E24656C656D656E742E636C6F736573742822666F726D22292C742E6C656E6774682626742E6F6666282272657365742E626F6F7473747261705377697463682229';
wwv_flow_imp.g_varchar2_table(96) := '2E72656D6F7665446174612822626F6F7473747261702D73776974636822292C746869732E24636F6E7461696E65722E6368696C6472656E28292E6E6F7428746869732E24656C656D656E74292E72656D6F766528292C746869732E24656C656D656E74';
wwv_flow_imp.g_varchar2_table(97) := '2E756E7772617028292E756E7772617028292E6F666628222E626F6F74737472617053776974636822292E72656D6F7665446174612822626F6F7473747261702D73776974636822292C746869732E24656C656D656E747D2C742E70726F746F74797065';
wwv_flow_imp.g_varchar2_table(98) := '2E5F77696474683D66756E6374696F6E28297B76617220742C653B72657475726E20743D746869732E246F6E2E61646428746869732E246F6666292C742E61646428746869732E246C6162656C292E63737328227769647468222C2222292C653D226175';
wwv_flow_imp.g_varchar2_table(99) := '746F223D3D3D746869732E6F7074696F6E732E68616E646C6557696474683F4D6174682E6D617828746869732E246F6E2E776964746828292C746869732E246F66662E77696474682829293A746869732E6F7074696F6E732E68616E646C655769647468';
wwv_flow_imp.g_varchar2_table(100) := '2C742E77696474682865292C746869732E246C6162656C2E77696474682866756E6374696F6E2874297B72657475726E2066756E6374696F6E28692C6E297B72657475726E226175746F22213D3D742E6F7074696F6E732E6C6162656C57696474683F74';
wwv_flow_imp.g_varchar2_table(101) := '2E6F7074696F6E732E6C6162656C57696474683A653E6E3F653A6E7D7D287468697329292C746869732E5F68616E646C6557696474683D746869732E246F6E2E6F75746572576964746828292C746869732E5F6C6162656C57696474683D746869732E24';
wwv_flow_imp.g_varchar2_table(102) := '6C6162656C2E6F75746572576964746828292C746869732E24636F6E7461696E65722E776964746828322A746869732E5F68616E646C6557696474682B746869732E5F6C6162656C5769647468292C746869732E24777261707065722E77696474682874';
wwv_flow_imp.g_varchar2_table(103) := '6869732E5F68616E646C6557696474682B746869732E5F6C6162656C5769647468297D2C742E70726F746F747970652E5F636F6E7461696E6572506F736974696F6E3D66756E6374696F6E28742C65297B72657475726E206E756C6C3D3D74262628743D';
wwv_flow_imp.g_varchar2_table(104) := '746869732E6F7074696F6E732E7374617465292C746869732E24636F6E7461696E65722E63737328226D617267696E2D6C656674222C66756E6374696F6E2865297B72657475726E2066756E6374696F6E28297B76617220693B72657475726E20693D5B';
wwv_flow_imp.g_varchar2_table(105) := '302C222D222B652E5F68616E646C6557696474682B227078225D2C652E6F7074696F6E732E696E64657465726D696E6174653F222D222B652E5F68616E646C6557696474682F322B227078223A743F652E6F7074696F6E732E696E76657273653F695B31';
wwv_flow_imp.g_varchar2_table(106) := '5D3A695B305D3A652E6F7074696F6E732E696E76657273653F695B305D3A695B315D7D7D287468697329292C653F73657454696D656F75742866756E6374696F6E28297B72657475726E206528297D2C3530293A766F696420307D2C742E70726F746F74';
wwv_flow_imp.g_varchar2_table(107) := '7970652E5F696E69743D66756E6374696F6E28297B76617220742C653B72657475726E20743D66756E6374696F6E2874297B72657475726E2066756E6374696F6E28297B72657475726E20742E736574507265764F7074696F6E7328292C742E5F776964';
wwv_flow_imp.g_varchar2_table(108) := '746828292C742E5F636F6E7461696E6572506F736974696F6E286E756C6C2C66756E6374696F6E28297B72657475726E20742E6F7074696F6E732E616E696D6174653F742E24777261707065722E616464436C61737328742E6F7074696F6E732E626173';
wwv_flow_imp.g_varchar2_table(109) := '65436C6173732B222D616E696D61746522293A766F696420307D297D7D2874686973292C746869732E24777261707065722E697328223A76697369626C6522293F7428293A653D692E736574496E74657276616C2866756E6374696F6E286E297B726574';
wwv_flow_imp.g_varchar2_table(110) := '75726E2066756E6374696F6E28297B72657475726E206E2E24777261707065722E697328223A76697369626C6522293F287428292C692E636C656172496E74657276616C286529293A766F696420307D7D2874686973292C3530297D2C742E70726F746F';
wwv_flow_imp.g_varchar2_table(111) := '747970652E5F656C656D656E7448616E646C6572733D66756E6374696F6E28297B72657475726E20746869732E24656C656D656E742E6F6E287B2273657450726576696F75734F7074696F6E732E626F6F747374726170537769746368223A66756E6374';
wwv_flow_imp.g_varchar2_table(112) := '696F6E2874297B72657475726E2066756E6374696F6E2865297B72657475726E20742E736574507265764F7074696F6E7328297D7D2874686973292C2270726576696F757353746174652E626F6F747374726170537769746368223A66756E6374696F6E';
wwv_flow_imp.g_varchar2_table(113) := '2874297B72657475726E2066756E6374696F6E2865297B72657475726E20742E6F7074696F6E733D742E707265764F7074696F6E732C742E6F7074696F6E732E696E64657465726D696E6174652626742E24777261707065722E616464436C6173732874';
wwv_flow_imp.g_varchar2_table(114) := '2E6F7074696F6E732E62617365436C6173732B222D696E64657465726D696E61746522292C742E24656C656D656E742E70726F702822636865636B6564222C742E6F7074696F6E732E7374617465292E7472696767657228226368616E67652E626F6F74';
wwv_flow_imp.g_varchar2_table(115) := '7374726170537769746368222C2130297D7D2874686973292C226368616E67652E626F6F747374726170537769746368223A66756E6374696F6E2874297B72657475726E2066756E6374696F6E28692C6E297B766172206F3B72657475726E20692E7072';
wwv_flow_imp.g_varchar2_table(116) := '6576656E7444656661756C7428292C692E73746F70496D6D65646961746550726F7061676174696F6E28292C6F3D742E24656C656D656E742E697328223A636865636B656422292C742E5F636F6E7461696E6572506F736974696F6E286F292C6F213D3D';
wwv_flow_imp.g_varchar2_table(117) := '742E6F7074696F6E732E73746174653F28742E6F7074696F6E732E73746174653D6F2C742E24777261707065722E746F67676C65436C61737328742E6F7074696F6E732E62617365436C6173732B222D6F666622292E746F67676C65436C61737328742E';
wwv_flow_imp.g_varchar2_table(118) := '6F7074696F6E732E62617365436C6173732B222D6F6E22292C6E3F766F696420303A28742E24656C656D656E742E697328223A726164696F222926266528225B6E616D653D27222B742E24656C656D656E742E6174747228226E616D6522292B22275D22';
wwv_flow_imp.g_varchar2_table(119) := '292E6E6F7428742E24656C656D656E74292E70726F702822636865636B6564222C2131292E7472696767657228226368616E67652E626F6F747374726170537769746368222C2130292C742E24656C656D656E742E747269676765722822737769746368';
wwv_flow_imp.g_varchar2_table(120) := '4368616E67652E626F6F747374726170537769746368222C5B6F5D2929293A766F696420307D7D2874686973292C22666F6375732E626F6F747374726170537769746368223A66756E6374696F6E2874297B72657475726E2066756E6374696F6E286529';
wwv_flow_imp.g_varchar2_table(121) := '7B72657475726E20652E70726576656E7444656661756C7428292C742E24777261707065722E616464436C61737328742E6F7074696F6E732E62617365436C6173732B222D666F637573656422297D7D2874686973292C22626C75722E626F6F74737472';
wwv_flow_imp.g_varchar2_table(122) := '6170537769746368223A66756E6374696F6E2874297B72657475726E2066756E6374696F6E2865297B72657475726E20652E70726576656E7444656661756C7428292C742E24777261707065722E72656D6F7665436C61737328742E6F7074696F6E732E';
wwv_flow_imp.g_varchar2_table(123) := '62617365436C6173732B222D666F637573656422297D7D2874686973292C226B6579646F776E2E626F6F747374726170537769746368223A66756E6374696F6E2874297B72657475726E2066756E6374696F6E2865297B696628652E7768696368262621';
wwv_flow_imp.g_varchar2_table(124) := '742E6F7074696F6E732E64697361626C6564262621742E6F7074696F6E732E726561646F6E6C792973776974636828652E7768696368297B636173652033373A72657475726E20652E70726576656E7444656661756C7428292C652E73746F70496D6D65';
wwv_flow_imp.g_varchar2_table(125) := '646961746550726F7061676174696F6E28292C742E7374617465282131293B636173652033393A72657475726E20652E70726576656E7444656661756C7428292C652E73746F70496D6D65646961746550726F7061676174696F6E28292C742E73746174';
wwv_flow_imp.g_varchar2_table(126) := '65282130297D7D7D2874686973297D297D2C742E70726F746F747970652E5F68616E646C6548616E646C6572733D66756E6374696F6E28297B72657475726E20746869732E246F6E2E6F6E2822636C69636B2E626F6F747374726170537769746368222C';
wwv_flow_imp.g_varchar2_table(127) := '66756E6374696F6E2874297B72657475726E2066756E6374696F6E2865297B72657475726E20652E70726576656E7444656661756C7428292C652E73746F7050726F7061676174696F6E28292C742E7374617465282131292C742E24656C656D656E742E';
wwv_flow_imp.g_varchar2_table(128) := '747269676765722822666F6375732E626F6F74737472617053776974636822297D7D287468697329292C746869732E246F66662E6F6E2822636C69636B2E626F6F747374726170537769746368222C66756E6374696F6E2874297B72657475726E206675';
wwv_flow_imp.g_varchar2_table(129) := '6E6374696F6E2865297B72657475726E20652E70726576656E7444656661756C7428292C652E73746F7050726F7061676174696F6E28292C742E7374617465282130292C742E24656C656D656E742E747269676765722822666F6375732E626F6F747374';
wwv_flow_imp.g_varchar2_table(130) := '72617053776974636822297D7D287468697329297D2C742E70726F746F747970652E5F6C6162656C48616E646C6572733D66756E6374696F6E28297B72657475726E20746869732E246C6162656C2E6F6E287B636C69636B3A66756E6374696F6E287429';
wwv_flow_imp.g_varchar2_table(131) := '7B72657475726E20742E73746F7050726F7061676174696F6E28297D2C226D6F757365646F776E2E626F6F74737472617053776974636820746F75636873746172742E626F6F747374726170537769746368223A66756E6374696F6E2874297B72657475';
wwv_flow_imp.g_varchar2_table(132) := '726E2066756E6374696F6E2865297B72657475726E20742E5F6472616753746172747C7C742E6F7074696F6E732E64697361626C65647C7C742E6F7074696F6E732E726561646F6E6C793F766F696420303A28652E70726576656E7444656661756C7428';
wwv_flow_imp.g_varchar2_table(133) := '292C652E73746F7050726F7061676174696F6E28292C742E5F6472616753746172743D28652E70616765587C7C652E6F726967696E616C4576656E742E746F75636865735B305D2E7061676558292D7061727365496E7428742E24636F6E7461696E6572';
wwv_flow_imp.g_varchar2_table(134) := '2E63737328226D617267696E2D6C65667422292C3130292C742E6F7074696F6E732E616E696D6174652626742E24777261707065722E72656D6F7665436C61737328742E6F7074696F6E732E62617365436C6173732B222D616E696D61746522292C742E';
wwv_flow_imp.g_varchar2_table(135) := '24656C656D656E742E747269676765722822666F6375732E626F6F7473747261705377697463682229297D7D2874686973292C226D6F7573656D6F76652E626F6F74737472617053776974636820746F7563686D6F76652E626F6F747374726170537769';
wwv_flow_imp.g_varchar2_table(136) := '746368223A66756E6374696F6E2874297B72657475726E2066756E6374696F6E2865297B76617220693B6966286E756C6C213D742E5F647261675374617274262628652E70726576656E7444656661756C7428292C693D28652E70616765587C7C652E6F';
wwv_flow_imp.g_varchar2_table(137) := '726967696E616C4576656E742E746F75636865735B305D2E7061676558292D742E5F6472616753746172742C2128693C2D742E5F68616E646C6557696474687C7C693E3029292972657475726E20742E5F64726167456E643D692C742E24636F6E746169';
wwv_flow_imp.g_varchar2_table(138) := '6E65722E63737328226D617267696E2D6C656674222C742E5F64726167456E642B22707822297D7D2874686973292C226D6F75736575702E626F6F74737472617053776974636820746F756368656E642E626F6F747374726170537769746368223A6675';
wwv_flow_imp.g_varchar2_table(139) := '6E6374696F6E2874297B72657475726E2066756E6374696F6E2865297B76617220693B696628742E5F6472616753746172742972657475726E20652E70726576656E7444656661756C7428292C742E6F7074696F6E732E616E696D6174652626742E2477';
wwv_flow_imp.g_varchar2_table(140) := '7261707065722E616464436C61737328742E6F7074696F6E732E62617365436C6173732B222D616E696D61746522292C742E5F64726167456E643F28693D742E5F64726167456E643E2D28742E5F68616E646C6557696474682F32292C742E5F64726167';
wwv_flow_imp.g_varchar2_table(141) := '456E643D21312C742E737461746528742E6F7074696F6E732E696E76657273653F21693A6929293A742E73746174652821742E6F7074696F6E732E7374617465292C742E5F6472616753746172743D21317D7D2874686973292C226D6F7573656C656176';
wwv_flow_imp.g_varchar2_table(142) := '652E626F6F747374726170537769746368223A66756E6374696F6E2874297B72657475726E2066756E6374696F6E2865297B72657475726E20742E246C6162656C2E7472696767657228226D6F75736575702E626F6F7473747261705377697463682229';
wwv_flow_imp.g_varchar2_table(143) := '7D7D2874686973297D297D2C742E70726F746F747970652E5F65787465726E616C4C6162656C48616E646C65723D66756E6374696F6E28297B76617220743B72657475726E20743D746869732E24656C656D656E742E636C6F7365737428226C6162656C';
wwv_flow_imp.g_varchar2_table(144) := '22292C742E6F6E2822636C69636B222C66756E6374696F6E2865297B72657475726E2066756E6374696F6E2869297B72657475726E20692E70726576656E7444656661756C7428292C692E73746F70496D6D65646961746550726F7061676174696F6E28';
wwv_flow_imp.g_varchar2_table(145) := '292C692E7461726765743D3D3D745B305D3F652E746F67676C65537461746528293A766F696420307D7D287468697329297D2C742E70726F746F747970652E5F666F726D48616E646C65723D66756E6374696F6E28297B76617220743B72657475726E20';
wwv_flow_imp.g_varchar2_table(146) := '743D746869732E24656C656D656E742E636C6F736573742822666F726D22292C742E646174612822626F6F7473747261702D73776974636822293F766F696420303A742E6F6E282272657365742E626F6F747374726170537769746368222C66756E6374';
wwv_flow_imp.g_varchar2_table(147) := '696F6E28297B72657475726E20692E73657454696D656F75742866756E6374696F6E28297B72657475726E20742E66696E642822696E70757422292E66696C7465722866756E6374696F6E28297B72657475726E20652874686973292E64617461282262';
wwv_flow_imp.g_varchar2_table(148) := '6F6F7473747261702D73776974636822297D292E656163682866756E6374696F6E28297B72657475726E20652874686973292E626F6F74737472617053776974636828227374617465222C746869732E636865636B6564297D297D2C31297D292E646174';
wwv_flow_imp.g_varchar2_table(149) := '612822626F6F7473747261702D737769746368222C2130297D2C742E70726F746F747970652E5F676574436C61737365733D66756E6374696F6E2874297B76617220692C6E2C6F2C733B69662821652E697341727261792874292972657475726E5B7468';
wwv_flow_imp.g_varchar2_table(150) := '69732E6F7074696F6E732E62617365436C6173732B222D222B745D3B666F72286E3D5B5D2C6F3D302C733D742E6C656E6774683B733E6F3B6F2B2B29693D745B6F5D2C6E2E7075736828746869732E6F7074696F6E732E62617365436C6173732B222D22';
wwv_flow_imp.g_varchar2_table(151) := '2B69293B72657475726E206E7D2C747D28292C652E666E2E626F6F7473747261705377697463683D66756E6374696F6E28297B76617220692C6F2C733B72657475726E206F3D617267756D656E74735B305D2C693D323C3D617267756D656E74732E6C65';
wwv_flow_imp.g_varchar2_table(152) := '6E6774683F742E63616C6C28617267756D656E74732C31293A5B5D2C733D746869732C746869732E656163682866756E6374696F6E28297B76617220742C613B72657475726E20743D652874686973292C613D742E646174612822626F6F747374726170';
wwv_flow_imp.g_varchar2_table(153) := '2D73776974636822292C617C7C742E646174612822626F6F7473747261702D737769746368222C613D6E6577206E28746869732C6F29292C22737472696E67223D3D747970656F66206F3F733D615B6F5D2E6170706C7928612C69293A766F696420307D';
wwv_flow_imp.g_varchar2_table(154) := '292C737D2C652E666E2E626F6F7473747261705377697463682E436F6E7374727563746F723D6E2C652E666E2E626F6F7473747261705377697463682E64656661756C74733D7B73746174653A21302C73697A653A6E756C6C2C616E696D6174653A2130';
wwv_flow_imp.g_varchar2_table(155) := '2C64697361626C65643A21312C726561646F6E6C793A21312C696E64657465726D696E6174653A21312C696E76657273653A21312C726164696F416C6C4F66663A21312C6F6E436F6C6F723A227072696D617279222C6F6666436F6C6F723A2264656661';
wwv_flow_imp.g_varchar2_table(156) := '756C74222C6F6E546578743A224F4E222C6F6666546578743A224F4646222C6C6162656C546578743A22266E6273703B222C68616E646C6557696474683A226175746F222C6C6162656C57696474683A226175746F222C62617365436C6173733A22626F';
wwv_flow_imp.g_varchar2_table(157) := '6F7473747261702D737769746368222C77726170706572436C6173733A2277726170706572222C6F6E496E69743A66756E6374696F6E28297B7D2C6F6E5377697463684368616E67653A66756E6374696F6E28297B7D7D7D2877696E646F772E6A517565';
wwv_flow_imp.g_varchar2_table(158) := '72792C77696E646F77297D292E63616C6C2874686973293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(24236946336296324)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'bootstrap-switch.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '746D6C207B0D0A2020626F782D73697A696E673A20626F726465722D626F783B0D0A2020666F6E742D66616D696C793A2027417269616C272C2073616E732D73657269663B0D0A2020666F6E742D73697A653A20313030253B0D0A7D0D0A0D0A2E6D6964';
wwv_flow_imp.g_varchar2_table(2) := '207B0D0A2020646973706C61793A20666C65783B0D0A2020616C69676E2D6974656D733A2063656E7465723B0D0A20206A7573746966792D636F6E74656E743A2063656E7465723B0D0A202070616464696E672D746F703A30656D3B0D0A7D0D0A0D0A0D';
wwv_flow_imp.g_varchar2_table(3) := '0A2F2A20537769746368207374617274732068657265202A2F0D0A2E726F636B6572207B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A20202F2A0D0A202053495A4520';
wwv_flow_imp.g_varchar2_table(4) := '4F46205357495443480D0A20203D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A2020416C6C2073697A65732061726520696E20656D202D207468657265666F72650D0A20206368616E67696E672074686520666F6E742D73697A6520686572650D0A202077696C';
wwv_flow_imp.g_varchar2_table(5) := '6C206368616E6765207468652073697A65206F6620746865207377697463682E0D0A2020536565202E726F636B65722D736D616C6C2062656C6F77206173206578616D706C652E0D0A20202A2F0D0A2020666F6E742D73697A653A2031656D3B0D0A2020';
wwv_flow_imp.g_varchar2_table(6) := '666F6E742D7765696768743A20626F6C643B0D0A2020746578742D616C69676E3A2063656E7465723B0D0A2020746578742D7472616E73666F726D3A207570706572636173653B0D0A2020636F6C6F723A20233838383B0D0A202077696474683A203765';
wwv_flow_imp.g_varchar2_table(7) := '6D3B0D0A20206865696768743A2034656D3B0D0A20206F766572666C6F773A2068696464656E3B0D0A2020626F726465722D626F74746F6D3A20302E35656D20736F6C696420236565653B0D0A7D0D0A0D0A2E726F636B65722D736D616C6C207B0D0A20';
wwv_flow_imp.g_varchar2_table(8) := '20666F6E742D73697A653A20302E3735656D3B202F2A2053697A65732074686520737769746368202A2F0D0A20206D617267696E3A2031656D3B0D0A7D0D0A0D0A2E726F636B65723A3A6265666F7265207B0D0A2020636F6E74656E743A2022223B0D0A';
wwv_flow_imp.g_varchar2_table(9) := '2020706F736974696F6E3A206162736F6C7574653B0D0A2020746F703A20302E35656D3B0D0A20206C6566743A20303B0D0A202072696768743A20303B0D0A2020626F74746F6D3A20303B0D0A20206261636B67726F756E642D636F6C6F723A20233939';
wwv_flow_imp.g_varchar2_table(10) := '393B0D0A2020626F726465723A20302E35656D20736F6C696420236565653B0D0A2020626F726465722D626F74746F6D3A20303B0D0A7D0D0A0D0A2E726F636B657220696E707574207B0D0A20206F7061636974793A20303B0D0A202077696474683A20';
wwv_flow_imp.g_varchar2_table(11) := '303B0D0A20206865696768743A20303B0D0A7D0D0A0D0A2E7377697463682D6C6566742C0D0A2E7377697463682D7269676874207B0D0A2020637572736F723A20706F696E7465723B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A2020';
wwv_flow_imp.g_varchar2_table(12) := '646973706C61793A20666C65783B0D0A2020616C69676E2D6974656D733A2063656E7465723B0D0A20206A7573746966792D636F6E74656E743A2063656E7465723B0D0A20206865696768743A20322E35656D3B0D0A202077696474683A2033656D3B0D';
wwv_flow_imp.g_varchar2_table(13) := '0A20207472616E736974696F6E3A20302E32733B0D0A7D0D0A0D0A2E7377697463682D6C656674207B0D0A20206865696768743A20322E34656D3B0D0A202077696474683A20322E3735656D3B0D0A20206C6566743A20302E3835656D3B0D0A2020626F';
wwv_flow_imp.g_varchar2_table(14) := '74746F6D3A20302E34656D3B0D0A20206261636B67726F756E642D636F6C6F723A20236464643B0D0A20207472616E73666F726D3A20726F746174652831356465672920736B657758283135646567293B0D0A7D0D0A0D0A2E7377697463682D72696768';
wwv_flow_imp.g_varchar2_table(15) := '74207B0D0A202072696768743A20302E35656D3B0D0A2020626F74746F6D3A20303B0D0A20206261636B67726F756E642D636F6C6F723A20236264353735373B0D0A2020636F6C6F723A20236666663B0D0A7D0D0A0D0A2E7377697463682D6C6566743A';
wwv_flow_imp.g_varchar2_table(16) := '3A6265666F72652C0D0A2E7377697463682D72696768743A3A6265666F7265207B0D0A2020636F6E74656E743A2022223B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A202077696474683A20302E34656D3B0D0A20206865696768743A';
wwv_flow_imp.g_varchar2_table(17) := '20322E3435656D3B0D0A2020626F74746F6D3A202D302E3435656D3B0D0A20206261636B67726F756E642D636F6C6F723A20236363633B0D0A20207472616E73666F726D3A20736B657759282D3635646567293B0D0A7D0D0A0D0A2E7377697463682D6C';
wwv_flow_imp.g_varchar2_table(18) := '6566743A3A6265666F7265207B0D0A20206C6566743A202D302E34656D3B0D0A7D0D0A0D0A2E7377697463682D72696768743A3A6265666F7265207B0D0A202072696768743A202D302E333735656D3B0D0A20206261636B67726F756E642D636F6C6F72';
wwv_flow_imp.g_varchar2_table(19) := '3A207472616E73706172656E743B0D0A20207472616E73666F726D3A20736B657759283635646567293B0D0A7D0D0A0D0A696E7075743A636865636B6564202B202E7377697463682D6C656674207B0D0A20202F2A6261636B67726F756E642D636F6C6F';
wwv_flow_imp.g_varchar2_table(20) := '723A20233030383464303B2A2F0D0A2020636F6C6F723A20236666663B0D0A2020626F74746F6D3A203070783B0D0A20206C6566743A20302E35656D3B0D0A20206865696768743A20322E35656D3B0D0A202077696474683A2033656D3B0D0A20207472';
wwv_flow_imp.g_varchar2_table(21) := '616E73666F726D3A20726F7461746528306465672920736B6577582830646567293B0D0A7D0D0A0D0A696E7075743A636865636B6564202B202E7377697463682D6C6566743A3A6265666F7265207B0D0A20206261636B67726F756E642D636F6C6F723A';
wwv_flow_imp.g_varchar2_table(22) := '207472616E73706172656E743B0D0A202077696474683A20332E30383333656D3B0D0A7D0D0A0D0A696E7075743A636865636B6564202B202E7377697463682D6C656674202B202E7377697463682D7269676874207B0D0A20206261636B67726F756E64';
wwv_flow_imp.g_varchar2_table(23) := '2D636F6C6F723A20236464643B0D0A2020636F6C6F723A20233838383B0D0A2020626F74746F6D3A20302E34656D3B0D0A202072696768743A20302E38656D3B0D0A20206865696768743A20322E34656D3B0D0A202077696474683A20322E3735656D3B';
wwv_flow_imp.g_varchar2_table(24) := '0D0A20207472616E73666F726D3A20726F74617465282D31356465672920736B657758282D3135646567293B0D0A7D0D0A0D0A696E7075743A636865636B6564202B202E7377697463682D6C656674202B202E7377697463682D72696768743A3A626566';
wwv_flow_imp.g_varchar2_table(25) := '6F7265207B0D0A20206261636B67726F756E642D636F6C6F723A20236363633B0D0A7D0D0A0D0A2F2A204B6579626F617264205573657273202A2F0D0A696E7075743A666F637573202B202E7377697463682D6C656674207B0D0A2020636F6C6F723A20';
wwv_flow_imp.g_varchar2_table(26) := '233333333B0D0A7D0D0A0D0A696E7075743A636865636B65643A666F637573202B202E7377697463682D6C656674207B0D0A2020636F6C6F723A20236666663B0D0A7D0D0A0D0A696E7075743A666F637573202B202E7377697463682D6C656674202B20';
wwv_flow_imp.g_varchar2_table(27) := '2E7377697463682D7269676874207B0D0A2020636F6C6F723A20236666663B0D0A7D0D0A0D0A696E7075743A636865636B65643A666F637573202B202E7377697463682D6C656674202B202E7377697463682D7269676874207B0D0A2020636F6C6F723A';
wwv_flow_imp.g_varchar2_table(28) := '20233333333B0D0A7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(24263818205645504)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'animatedButton.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F0D0A2F2F20676C6173';
wwv_flow_imp.g_varchar2_table(2) := '676F775F73696D706C655F636865636B626F780D0A2F2F0D0A2F2F2050726F7669646573206120706C75672D696E20737065636966696320696D706C656D656E746174696F6E20666F72206120636865636B626F78206974656D2E20546865206974656D';
wwv_flow_imp.g_varchar2_table(3) := '206F6E2074686520706167650D0A2F2F2073686F756C64206265206120636865636B626F782C20692E652E203C696E70757420747970653D22636865636B626F782220616E64206E616D652073686F756C6420626520796F7572206974656D206E616D65';
wwv_flow_imp.g_varchar2_table(4) := '0D0A2F2F20692E652E206E616D653D275031325F4E414D45270D0A2F2F0D0A2F2F20506172616D730D0A2F2F0D0A2F2F206974656D4E616D65202D20746865206974656D206E616D652C20692E652E206E616D653D275031325F4E414D45270D0A2F2F20';
wwv_flow_imp.g_varchar2_table(5) := '636865636B626F7856616C756573202D2074686520636865636B20616E6420756E636865636B65642076616C7565732C20692E652E20592F4E0D0A2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F';
wwv_flow_imp.g_varchar2_table(6) := '2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F0D0A66756E6374696F6E20676C6173676F775F73696D706C655F636865636B626F78286974656D4E616D652C20636865636B';
wwv_flow_imp.g_varchar2_table(7) := '626F7856616C75657329207B0D0A202020202F2F206765742074686520636865636B626F78207573696E67204A51756572790D0A2020202076617220636865636B426F78203D20617065782E6A517565727928222322202B206974656D4E616D65293B0D';
wwv_flow_imp.g_varchar2_table(8) := '0A0D0A202020202F2F207768656E2074686520636865636B626F78206368616E6765732028636C69636B6564292073657420746865206974656D2076616C75650D0A20202020617065782E6A517565727928222322202B206974656D4E616D65292E6368';
wwv_flow_imp.g_varchar2_table(9) := '616E6765287365744974656D56616C7565293B0D0A202020200D0A202020202F2F207365742074686520636865636B626F78206974656D2076616C756520646570656E64696E67206F6E20776865746865722069747320636865636B6564206F72206E6F';
wwv_flow_imp.g_varchar2_table(10) := '742E0D0A2020202066756E6374696F6E207365744974656D56616C75652829207B0D0A20202020202020202F2F2074686520636865636B626F7820686173206265656E20636C69636B65642C20736574207468652076616C756520646570656E64696E67';
wwv_flow_imp.g_varchar2_table(11) := '206F6E2073656C656374696F6E202D20636865636B6564206F72206E6F7420636865636B65640D0A2020202020202020636865636B426F782E76616C2828636865636B426F782E697328223A636865636B65642229203D3D3D207472756529203F206368';
wwv_flow_imp.g_varchar2_table(12) := '65636B626F7856616C7565732E636865636B6564203A20636865636B626F7856616C7565732E756E636865636B6564293B0D0A202020207D0D0A0D0A202020202F2F20617065782E6974656D2E637265617465200D0A202020202F2F0D0A202020202F2F';
wwv_flow_imp.g_varchar2_table(13) := '2050726F7669646573206120706C75672D696E20737065636966696320696D706C656D656E746174696F6E20666F7220746865206974656D2E0D0A202020202F2F205468697320697320776865726520776520676574204150455820746F207365742F67';
wwv_flow_imp.g_varchar2_table(14) := '657420746865206974656D207573696E67207468652076616C756573206F6E2074686520706167652E0D0A202020202F2F0D0A202020202F2F20506172616D730D0A202020202F2F0D0A202020202F2F206974656D4E616D65203A205061676520697465';
wwv_flow_imp.g_varchar2_table(15) := '6D0D0A202020202F2F2066756E6374696F6E73206E656564656420746F20637573746F6D697A6520746865204170706C69636174696F6E2045787072657373206974656D206F626A656374206265686176696F722E0D0A20202020617065782E6974656D';
wwv_flow_imp.g_varchar2_table(16) := '2E637265617465286974656D4E616D652C207B0D0A2020202020200D0A202020202020202073657456616C75653A2066756E6374696F6E286629207B0D0A202020202020202020202020636F6E736F6C652E6C6F6728277365742076616C75652027202B';
wwv_flow_imp.g_varchar2_table(17) := '20636865636B426F782E76616C2829293B0D0A2020202020202020202020207365744974656D56616C756528290D0A20202020202020207D2C0D0A202020202020202067657456616C75653A2066756E6374696F6E2829207B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(18) := '202020636F6E736F6C652E6C6F6728276765742076616C75652027202B20636865636B426F782E76616C2829293B0D0A20202020202020202020202072657475726E20636865636B426F782E76616C28290D0A20202020202020207D0D0A202020207D29';
wwv_flow_imp.g_varchar2_table(19) := '3B200D0A202020200D0A7D3B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26316145865016092)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'glasgow_apex_simple_checkbox.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '66756E6374696F6E20676C6173676F775F73696D706C655F636865636B626F7828652C63297B76617220613D617065782E6A5175657279282223222B65293B66756E6374696F6E206C28297B612E76616C2821303D3D3D612E697328223A636865636B65';
wwv_flow_imp.g_varchar2_table(2) := '6422293F632E636865636B65643A632E756E636865636B6564297D617065782E6A5175657279282223222B65292E6368616E6765286C292C617065782E6974656D2E63726561746528652C7B73657456616C75653A66756E6374696F6E2865297B636F6E';
wwv_flow_imp.g_varchar2_table(3) := '736F6C652E6C6F6728227365742076616C756520222B612E76616C2829292C6C28297D2C67657456616C75653A66756E6374696F6E28297B72657475726E20636F6E736F6C652E6C6F6728226765742076616C756520222B612E76616C2829292C612E76';
wwv_flow_imp.g_varchar2_table(4) := '616C28297D7D297D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26413337394084626)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'glasgow_apex_simple_checkbox.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A2A0D0A202A20436865636B626F7865730D0A202A2F0D0A2E636865636B626F78207B0D0A2020637572736F723A20706F696E7465723B0D0A20202D7765626B69742D7461702D686967686C696768742D636F6C6F723A207472616E73706172656E74';
wwv_flow_imp.g_varchar2_table(2) := '3B0D0A20202D7765626B69742D757365722D73656C6563743A206E6F6E653B0D0A20202D6D6F7A2D757365722D73656C6563743A206E6F6E653B0D0A2020757365722D73656C6563743A206E6F6E653B0D0A7D0D0A2E636865636B626F78203E20696E70';
wwv_flow_imp.g_varchar2_table(3) := '75745B747970653D22636865636B626F78225D207B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A20206F7061636974793A20303B0D0A20207A2D696E6465783A202D313B0D0A7D0D0A0D0A2E636865636B626F785F5F69636F6E207B0D';
wwv_flow_imp.g_varchar2_table(4) := '0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A20202F2A2044656661756C74205374617465202A2F0D0A2020636F6C6F723A20233939393B0D0A20202F2A20416374697665205374617465202A2F0D0A7D0D0A696E7075745B747970';
wwv_flow_imp.g_varchar2_table(5) := '653D22636865636B626F78225D3A636865636B6564207E202E636865636B626F785F5F69636F6E207B0D0A2020636F6C6F723A20233241374445413B0D0A7D0D0A0D0A2F2A204945362D382046616C6C6261636B202A2F0D0A406D65646961205C307363';
wwv_flow_imp.g_varchar2_table(6) := '7265656E5C2C73637265656E5C39207B0D0A20202E636865636B626F785F5F69636F6E207B0D0A20202020646973706C61793A206E6F6E653B0D0A20207D0D0A0D0A20202E636865636B626F78203E20696E7075745B747970653D22636865636B626F78';
wwv_flow_imp.g_varchar2_table(7) := '225D207B0D0A20202020706F736974696F6E3A207374617469633B0D0A20207D0D0A7D0D0A2F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0D0A202A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0D0A20';
wwv_flow_imp.g_varchar2_table(8) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0D0A202A2048656C706572730D0A202A2F0D0A2E636865636B626F785F5F69636F6E3A6265666F7265207B0D0A2020666F6E742D66616D696C793A202269636F6E73223B0D0A2020';
wwv_flow_imp.g_varchar2_table(9) := '737065616B3A206E6F6E653B0D0A2020666F6E742D7374796C653A206E6F726D616C3B0D0A2020666F6E742D7765696768743A206E6F726D616C3B0D0A2020666F6E742D76617269616E743A206E6F726D616C3B0D0A2020746578742D7472616E73666F';
wwv_flow_imp.g_varchar2_table(10) := '726D3A206E6F6E653B0D0A20202F2A2042657474657220466F6E742052656E646572696E67203D3D3D3D3D3D3D3D3D3D3D202A2F0D0A20202D7765626B69742D666F6E742D736D6F6F7468696E673A20616E7469616C69617365643B0D0A20202D6D6F7A';
wwv_flow_imp.g_varchar2_table(11) := '2D6F73782D666F6E742D736D6F6F7468696E673A20677261797363616C653B0D0A7D0D0A0D0A2E69636F6E2D2D636865636B3A6265666F72652C20696E7075745B747970653D22636865636B626F78225D3A636865636B6564207E202E636865636B626F';
wwv_flow_imp.g_varchar2_table(12) := '785F5F69636F6E3A6265666F7265207B0D0A2020636F6E74656E743A20225C65363031223B0D0A7D0D0A0D0A2E69636F6E2D2D636865636B2D656D7074793A6265666F72652C202E636865636B626F785F5F69636F6E3A6265666F7265207B0D0A202063';
wwv_flow_imp.g_varchar2_table(13) := '6F6E74656E743A20225C65363030223B0D0A7D0D0A0D0A40666F6E742D66616365207B0D0A2020666F6E742D66616D696C793A202269636F6E73223B0D0A2020666F6E742D7765696768743A206E6F726D616C3B0D0A2020666F6E742D7374796C653A20';
wwv_flow_imp.g_varchar2_table(14) := '6E6F726D616C3B0D0A20207372633A2075726C2822646174613A6170706C69636174696F6E2F782D666F6E742D776F66663B636861727365743D7574662D383B6261736536342C64303947526B3955564538414141523441416F41414141414244414141';
wwv_flow_imp.g_varchar2_table(15) := '41414141414141414141414141414141414141414141414141414141414244526B596741414141394141414150674141414434665A5541564539544C7A494141414873414141415941414141474149497679335932316863414141416B77414141424D41';
wwv_flow_imp.g_varchar2_table(16) := '414141544270567A46686E59584E77414141436D4141414141674141414149414141414547686C5957514141414B67414141414E674141414459416573777A6147686C59514141417467414141416B414141414A4150694165646F62585234414141432F';
wwv_flow_imp.g_varchar2_table(17) := '414141414267414141415942514141414731686548414141414D55414141414267414141415941426C4141626D46745A5141414178774141414535414141424F555159744E5A7762334E304141414557414141414341414141416741414D414141454142';
wwv_flow_imp.g_varchar2_table(18) := '4151414151454243476C6A623231766232344141514941415141362B4277432B4273442B42674548676F414756502F693473654367415A552F2B4C69777748693276346C50683042523041414142384478304141414342455230414141414A4851414141';
wwv_flow_imp.g_varchar2_table(19) := '4F3853414163424151675045524D5747794270593239746232397561574E7662573976626E5577645446314D6A4231525459774D4856464E6A41784141414341596B41424141474151454542776F4E4C3258386C4137386C4137386C4137376C41364C2B';
wwv_flow_imp.g_varchar2_table(20) := '485156692F79552B4A534C692F69552F4A534C42643833466666736934763737507673693476333741554F692F6830465976386C50695569347633337A6333692F73332B2B794C692F6673397A654C33393846397743464666744E2B30354A7A55644939';
wwv_flow_imp.g_varchar2_table(21) := '78723747766552393546487A77554F2B4A51552B4A51566977774B41414D4341414751414155414141464D4157594141414248415577425A6741414150554147514345414141414141414141414141414141414141414141524141414141414141414141';
wwv_flow_imp.g_varchar2_table(22) := '4141414141414141414141514141413567454234502F672F2B414234414167414141414151414141414141414141414141414149414141414141414167414141414D414141415541414D4141514141414251414241413441414141436741494141494141';
wwv_flow_imp.g_varchar2_table(23) := '6741424143446D41662F392F2F3841414141414143446D41502F392F2F384141662F6A4767514141774142414141414141414141414141414141424141482F2F77415041414541414141414141436B59436667587738383951414C41674141414141417A';
wwv_flow_imp.g_varchar2_table(24) := '3635467577414141414450726B57374141442F344149414165414141414149414149414141414141414141415141414165442F34414141416741414141414141674141415141414141414141414141414141414141414141415941414141414141414141';
wwv_flow_imp.g_varchar2_table(25) := '4141414141414241414141416741414141494141414141414641414141594141414141414134417267414241414141414141424141344141414142414141414141414341413441527741424141414141414144414134414A414142414141414141414541';
wwv_flow_imp.g_varchar2_table(26) := '41344156514142414141414141414641425941446741424141414141414147414163414D674142414141414141414B414367415977414441414545435141424141344141414144414145454351414341413441527741444141454543514144414134414A';
wwv_flow_imp.g_varchar2_table(27) := '41414441414545435141454141344156514144414145454351414641425941446741444141454543514147414134414F514144414145454351414B414367415977427041474D41627742744147384162774275414659415A51427941484D416151427641';
wwv_flow_imp.g_varchar2_table(28) := '47344149414178414334414D41427041474D4162774274414738416277427561574E76625739766267427041474D41627742744147384162774275414649415A51426E4148554162414268414849416151426A4147384162514276414738416267424841';
wwv_flow_imp.g_varchar2_table(29) := '4755416267426C4148494159514230414755415A414167414749416551416741456B4159774276414530416277427641473441414141414177414141414141414141414141414141414141414141414141414141414141414141414141414141413D3D22';
wwv_flow_imp.g_varchar2_table(30) := '2920666F726D61742822776F666622293B0D0A7D0D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26414630261822307)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'ripple.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '0A0A0A2E6C6162656C2D2D636865636B626F78207B0A2020706F736974696F6E3A2072656C61746976653B0A20206D617267696E3A20302E3572656D3B0A2020666F6E742D66616D696C793A20417269616C2C2073616E732D73657269663B0A20206C69';
wwv_flow_imp.g_varchar2_table(2) := '6E652D6865696768743A20313335253B0A2020637572736F723A20706F696E7465723B0A7D0A0A0A2E6D6174657269616C2D636865636B626F78207B0A2020706F736974696F6E3A2072656C61746976653B0A2020746F703A202D302E33373572656D3B';
wwv_flow_imp.g_varchar2_table(3) := '0A20206D617267696E3A2030203172656D203020303B0A2020637572736F723A20706F696E7465723B0A7D0A2E6D6174657269616C2D636865636B626F783A6265666F7265207B0A20202D7765626B69742D7472616E736974696F6E3A20616C6C20302E';
wwv_flow_imp.g_varchar2_table(4) := '337320656173652D696E2D6F75743B0A20202D6D6F7A2D7472616E736974696F6E3A20616C6C20302E337320656173652D696E2D6F75743B0A20207472616E736974696F6E3A20616C6C20302E337320656173652D696E2D6F75743B0A2020636F6E7465';
wwv_flow_imp.g_varchar2_table(5) := '6E743A2022223B0A2020706F736974696F6E3A206162736F6C7574653B0A20206C6566743A20303B0A20207A2D696E6465783A20313B0A202077696474683A203172656D3B0A20206865696768743A203172656D3B0A2020626F726465723A2032707820';
wwv_flow_imp.g_varchar2_table(6) := '736F6C696420236632663266323B0A7D0A2E6D6174657269616C2D636865636B626F783A636865636B65643A6265666F7265207B0A20202D7765626B69742D7472616E73666F726D3A20726F74617465282D3435646567293B0A20202D6D6F7A2D747261';
wwv_flow_imp.g_varchar2_table(7) := '6E73666F726D3A20726F74617465282D3435646567293B0A20202D6D732D7472616E73666F726D3A20726F74617465282D3435646567293B0A20202D6F2D7472616E73666F726D3A20726F74617465282D3435646567293B0A20207472616E73666F726D';
wwv_flow_imp.g_varchar2_table(8) := '3A20726F74617465282D3435646567293B0A20206865696768743A20302E3572656D3B0A2020626F726465722D636F6C6F723A20233030393638383B0A2020626F726465722D746F702D7374796C653A206E6F6E653B0A2020626F726465722D72696768';
wwv_flow_imp.g_varchar2_table(9) := '742D7374796C653A206E6F6E653B0A7D0A2E6D6174657269616C2D636865636B626F783A6166746572207B0A2020636F6E74656E743A2022223B0A2020706F736974696F6E3A206162736F6C7574653B0A2020746F703A202D302E31323572656D3B0A20';
wwv_flow_imp.g_varchar2_table(10) := '206C6566743A20303B0A202077696474683A20312E3172656D3B0A20206865696768743A20312E3172656D3B0A20206261636B67726F756E643A20236666663B0A2020637572736F723A20706F696E7465723B0A7D0A0A2E627574746F6E2D2D726F756E';
wwv_flow_imp.g_varchar2_table(11) := '64207B0A20202D7765626B69742D7472616E736974696F6E3A20302E3373206261636B67726F756E6420656173652D696E2D6F75743B0A20202D6D6F7A2D7472616E736974696F6E3A20302E3373206261636B67726F756E6420656173652D696E2D6F75';
wwv_flow_imp.g_varchar2_table(12) := '743B0A20207472616E736974696F6E3A20302E3373206261636B67726F756E6420656173652D696E2D6F75743B0A202077696474683A203272656D3B0A20206865696768743A203272656D3B0A20206261636B67726F756E643A20233536373766633B0A';
wwv_flow_imp.g_varchar2_table(13) := '2020626F726465722D7261646975733A203530253B0A2020626F782D736861646F773A203020302E31323572656D20302E3331323572656D2030207267626128302C20302C20302C20302E3235293B0A2020636F6C6F723A20236666663B0A2020746578';
wwv_flow_imp.g_varchar2_table(14) := '742D6465636F726174696F6E3A206E6F6E653B0A2020746578742D616C69676E3A2063656E7465723B0A7D0A2E627574746F6E2D2D726F756E642069207B0A2020666F6E742D73697A653A203172656D3B0A20206C696E652D6865696768743A20323230';
wwv_flow_imp.g_varchar2_table(15) := '253B0A2020766572746963616C2D616C69676E3A206D6964646C653B0A7D0A2E627574746F6E2D2D726F756E643A686F766572207B0A20206261636B67726F756E643A20233362353063653B0A7D0A0A2E627574746F6E2D2D737469636B79207B0A2020';
wwv_flow_imp.g_varchar2_table(16) := '706F736974696F6E3A2066697865643B0A202072696768743A203272656D3B0A2020746F703A20313672656D3B0A7D0A0A2E636F6E74656E74207B0A20202D7765626B69742D616E696D6174696F6E2D6475726174696F6E3A20302E34733B0A2020616E';
wwv_flow_imp.g_varchar2_table(17) := '696D6174696F6E2D6475726174696F6E3A20302E34733B0A20202D7765626B69742D616E696D6174696F6E2D66696C6C2D6D6F64653A20626F74683B0A2020616E696D6174696F6E2D66696C6C2D6D6F64653A20626F74683B0A20202D7765626B69742D';
wwv_flow_imp.g_varchar2_table(18) := '616E696D6174696F6E2D6E616D653A20736C69646555703B0A2020616E696D6174696F6E2D6E616D653A20736C69646555703B0A20202D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A2063756269632D62657A6965';
wwv_flow_imp.g_varchar2_table(19) := '7228302E342C20302C20302E322C2031293B0A2020616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A2063756269632D62657A69657228302E342C20302C20302E322C2031293B0A7D0A0A402D7765626B69742D6B65796672616D657320';
wwv_flow_imp.g_varchar2_table(20) := '736C6964655570207B0A20203025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C6174655928362E323572656D293B0A202020207472616E73666F726D3A207472616E736C6174655928362E323572656D293B0A20207D';
wwv_flow_imp.g_varchar2_table(21) := '0A202031303025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C617465592830293B0A202020207472616E73666F726D3A207472616E736C617465592830293B0A20207D0A7D0A406B65796672616D657320736C696465';
wwv_flow_imp.g_varchar2_table(22) := '5570207B0A20203025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C6174655928362E323572656D293B0A202020207472616E73666F726D3A207472616E736C6174655928362E323572656D293B0A20207D0A20203130';
wwv_flow_imp.g_varchar2_table(23) := '3025207B0A202020202D7765626B69742D7472616E73666F726D3A207472616E736C617465592830293B0A202020207472616E73666F726D3A207472616E736C617465592830293B0A20207D0A7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26461169936120331)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'material-checkbox.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '40696D706F72742075726C282268747470733A2F2F666F6E74732E676F6F676C65617069732E636F6D2F6373733F66616D696C793D517569636B73616E643A3430302C37303026646973706C61793D7377617022293B0A0A0A2E626F78207B0A20207769';
wwv_flow_imp.g_varchar2_table(2) := '6474683A2033303070783B0A20206D617267696E3A203235707820303B0A2020646973706C61793A20666C65783B0A2020616C69676E2D6974656D733A2063656E7465723B0A2020757365722D73656C6563743A206E6F6E653B0A7D0A2E626F78206C61';
wwv_flow_imp.g_varchar2_table(3) := '62656C207B0A2020666F6E742D73697A653A20323670783B0A2020636F6C6F723A20233444344434443B0A2020706F736974696F6E3A206162736F6C7574653B0A20207A2D696E6465783A2031303B0A202070616464696E672D6C6566743A2035307078';
wwv_flow_imp.g_varchar2_table(4) := '3B0A2020637572736F723A20706F696E7465723B0A7D0A2E626F7820696E707574207B0A20206F7061636974793A20303B0A20207669736962696C6974793A2068696464656E3B0A2020706F736974696F6E3A206162736F6C7574653B0A7D0A2E626F78';
wwv_flow_imp.g_varchar2_table(5) := '20696E7075743A636865636B6564207E202E636865636B207B0A2020626F726465722D636F6C6F723A20233030454139303B0A2020626F782D736861646F773A2030707820307078203070782031357078202330304541393020696E7365743B0A7D0A2E';
wwv_flow_imp.g_varchar2_table(6) := '626F7820696E7075743A636865636B6564207E202E636865636B3A3A6166746572207B0A20206F7061636974793A20313B0A20207472616E73666F726D3A207363616C652831293B0A7D0A2E626F78202E636865636B207B0A202077696474683A203330';
wwv_flow_imp.g_varchar2_table(7) := '70783B0A20206865696768743A20333070783B0A2020646973706C61793A20666C65783B0A20206A7573746966792D636F6E74656E743A2063656E7465723B0A2020616C69676E2D6974656D733A2063656E7465723B0A2020706F736974696F6E3A2061';
wwv_flow_imp.g_varchar2_table(8) := '62736F6C7574653B0A2020626F726465722D7261646975733A2031303070783B0A20206261636B67726F756E642D636F6C6F723A20234646463B0A2020626F726465723A2032707820736F6C696420677265793B0A2020626F782D736861646F773A2030';
wwv_flow_imp.g_varchar2_table(9) := '7078203070782030707820307078202330304541393020696E7365743B0A20207472616E736974696F6E3A20616C6C20302E3135732063756269632D62657A69657228302C20312E30352C20302E37322C20312E3037293B0A7D0A2E626F78202E636865';
wwv_flow_imp.g_varchar2_table(10) := '636B3A3A6166746572207B0A2020636F6E74656E743A2022223B0A202077696474683A20313030253B0A20206865696768743A20313030253B0A20206F7061636974793A20303B0A20207A2D696E6465783A20343B0A2020706F736974696F6E3A206162';
wwv_flow_imp.g_varchar2_table(11) := '736F6C7574653B0A20207472616E73666F726D3A207363616C652830293B0A20206261636B67726F756E642D73697A653A203530253B0A20206261636B67726F756E642D696D6167653A2075726C282268747470733A2F2F73362E7069636F66696C652E';
wwv_flow_imp.g_varchar2_table(12) := '636F6D2F642F383339323330363636382F62616363383838632D626564372D343161392D626632342D6636666630373138663437312F636865636B6D61726B2E73766722293B0A20206261636B67726F756E642D7265706561743A206E6F2D7265706561';
wwv_flow_imp.g_varchar2_table(13) := '743B0A20206261636B67726F756E642D706F736974696F6E3A2063656E7465723B0A20207472616E736974696F6E2D64656C61793A20302E32732021696D706F7274616E743B0A20207472616E736974696F6E3A20616C6C20302E323573206375626963';
wwv_flow_imp.g_varchar2_table(14) := '2D62657A69657228302C20312E30352C20302E37322C20312E3037293B0A7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26515729030382498)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'soft-toggle-switch.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E636865636B626F787B637572736F723A706F696E7465723B2D7765626B69742D7461702D686967686C696768742D636F6C6F723A7472616E73706172656E743B2D7765626B69742D757365722D73656C6563743A6E6F6E653B2D6D6F7A2D757365722D';
wwv_flow_imp.g_varchar2_table(2) := '73656C6563743A6E6F6E653B757365722D73656C6563743A6E6F6E657D2E636865636B626F783E696E7075745B747970653D636865636B626F785D7B706F736974696F6E3A6162736F6C7574653B6F7061636974793A303B7A2D696E6465783A2D317D2E';
wwv_flow_imp.g_varchar2_table(3) := '636865636B626F785F5F69636F6E7B646973706C61793A696E6C696E652D626C6F636B3B636F6C6F723A233939397D696E7075745B747970653D636865636B626F785D3A636865636B65647E2E636865636B626F785F5F69636F6E7B636F6C6F723A2332';
wwv_flow_imp.g_varchar2_table(4) := '61376465617D406D65646961205C3073637265656E5C2C73637265656E5C39207B2E636865636B626F785F5F69636F6E7B646973706C61793A6E6F6E657D2E636865636B626F783E696E7075745B747970653D636865636B626F785D7B706F736974696F';
wwv_flow_imp.g_varchar2_table(5) := '6E3A7374617469637D7D2E636865636B626F785F5F69636F6E3A6265666F72657B666F6E742D66616D696C793A2269636F6E73223B737065616B3A6E6F6E653B666F6E742D7374796C653A6E6F726D616C3B666F6E742D7765696768743A3430303B666F';
wwv_flow_imp.g_varchar2_table(6) := '6E742D76617269616E743A6E6F726D616C3B746578742D7472616E73666F726D3A6E6F6E653B2D7765626B69742D666F6E742D736D6F6F7468696E673A616E7469616C69617365643B2D6D6F7A2D6F73782D666F6E742D736D6F6F7468696E673A677261';
wwv_flow_imp.g_varchar2_table(7) := '797363616C657D2E69636F6E2D2D636865636B3A6265666F72652C696E7075745B747970653D636865636B626F785D3A636865636B65647E2E636865636B626F785F5F69636F6E3A6265666F72657B636F6E74656E743A225C65363031227D2E63686563';
wwv_flow_imp.g_varchar2_table(8) := '6B626F785F5F69636F6E3A6265666F72652C2E69636F6E2D2D636865636B2D656D7074793A6265666F72657B636F6E74656E743A225C65363030227D40666F6E742D666163657B666F6E742D66616D696C793A2269636F6E73223B666F6E742D77656967';
wwv_flow_imp.g_varchar2_table(9) := '68743A3430303B666F6E742D7374796C653A6E6F726D616C3B7372633A75726C28646174613A6170706C69636174696F6E2F782D666F6E742D776F66663B636861727365743D7574662D383B6261736536342C64303947526B3955564538414141523441';
wwv_flow_imp.g_varchar2_table(10) := '416F4141414141424441414141414141414141414141414141414141414141414141414141414141414244526B596741414141394141414150674141414434665A5541564539544C7A494141414873414141415941414141474149497679335932316863';
wwv_flow_imp.g_varchar2_table(11) := '414141416B77414141424D41414141544270567A46686E59584E77414141436D4141414141674141414149414141414547686C5957514141414B67414141414E674141414459416573777A6147686C59514141417467414141416B414141414A41506941';
wwv_flow_imp.g_varchar2_table(12) := '65646F62585234414141432F414141414267414141415942514141414731686548414141414D55414141414267414141415941426C4141626D46745A5141414178774141414535414141424F555159744E5A7762334E3041414145574141414143414141';
wwv_flow_imp.g_varchar2_table(13) := '41416741414D4141414541424151414151454243476C6A623231766232344141514941415141362B4277432B4273442B42674548676F414756502F693473654367415A552F2B4C69777748693276346C5068304252304141414238447830414141434245';
wwv_flow_imp.g_varchar2_table(14) := '5230414141414A48514141414F3853414163424151675045524D5747794270593239746232397561574E7662573976626E5577645446314D6A4231525459774D4856464E6A41784141414341596B41424141474151454542776F4E4C3258386C4137386C';
wwv_flow_imp.g_varchar2_table(15) := '4137386C4137376C41364C2B485156692F79552B4A534C692F69552F4A534C42643833466666736934763737507673693476333741554F692F6830465976386C50695569347633337A6333692F73332B2B794C692F6673397A654C333938463977434646';
wwv_flow_imp.g_varchar2_table(16) := '66744E2B30354A7A5564493978723747766552393546487A77554F2B4A51552B4A51566977774B41414D4341414751414155414141464D4157594141414248415577425A6741414150554147514345414141414141414141414141414141414141414141';
wwv_flow_imp.g_varchar2_table(17) := '5241414141414141414141414141414141414141414141514141413567454234502F672F2B414234414167414141414151414141414141414141414141414149414141414141414167414141414D414141415541414D4141514141414251414241413441';
wwv_flow_imp.g_varchar2_table(18) := '4141414367414941414941416741424143446D41662F392F2F3841414141414143446D41502F392F2F384141662F6A4767514141774142414141414141414141414141414141424141482F2F77415041414541414141414141436B594366675877383839';
wwv_flow_imp.g_varchar2_table(19) := '51414C41674141414141417A3635467577414141414450726B57374141442F344149414165414141414149414149414141414141414141415141414165442F34414141416741414141414141674141415141414141414141414141414141414141414141';
wwv_flow_imp.g_varchar2_table(20) := '4159414141414141414141414141414141414241414141416741414141494141414141414641414141594141414141414134417267414241414141414141424141344141414142414141414141414341413441527741424141414141414144414134414A';
wwv_flow_imp.g_varchar2_table(21) := '41414241414141414141454141344156514142414141414141414641425941446741424141414141414147414163414D674142414141414141414B4143674159774144414145454351414241413441414141444141454543514143414134415277414441';
wwv_flow_imp.g_varchar2_table(22) := '41454543514144414134414A41414441414545435141454141344156514144414145454351414641425941446741444141454543514147414134414F514144414145454351414B414367415977427041474D41627742744147384162774275414659415A';
wwv_flow_imp.g_varchar2_table(23) := '51427941484D41615142764147344149414178414334414D41427041474D4162774274414738416277427561574E76625739766267427041474D41627742744147384162774275414649415A51426E4148554162414268414849416151426A4147384162';
wwv_flow_imp.g_varchar2_table(24) := '5142764147384162674248414755416267426C4148494159514230414755415A414167414749416551416741456B415977427641453041627742764147344141414141417741414141414141414141414141414141414141414141414141414141414141';
wwv_flow_imp.g_varchar2_table(25) := '4141414141414141413D3D2920666F726D61742822776F666622297D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26536977038780324)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'ripple.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A2A0D0A202A20436865636B626F7865730D0A202A2F0D0A2E636865636B626F78207B0D0A2020637572736F723A20706F696E7465723B0D0A20202D7765626B69742D7461702D686967686C696768742D636F6C6F723A207472616E73706172656E74';
wwv_flow_imp.g_varchar2_table(2) := '3B0D0A20202D7765626B69742D757365722D73656C6563743A206E6F6E653B0D0A20202D6D6F7A2D757365722D73656C6563743A206E6F6E653B0D0A2020757365722D73656C6563743A206E6F6E653B0D0A7D0D0A2E636865636B626F78203E20696E70';
wwv_flow_imp.g_varchar2_table(3) := '75745B747970653D22636865636B626F78225D207B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A20206F7061636974793A20303B0D0A20207A2D696E6465783A202D313B0D0A7D0D0A0D0A2E636865636B626F785F5F69636F6E207B0D';
wwv_flow_imp.g_varchar2_table(4) := '0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A20202F2A2044656661756C74205374617465202A2F0D0A2020636F6C6F723A20233939393B0D0A20202F2A20416374697665205374617465202A2F0D0A7D0D0A696E7075745B747970';
wwv_flow_imp.g_varchar2_table(5) := '653D22636865636B626F78225D3A636865636B6564207E202E636865636B626F785F5F69636F6E207B0D0A2020636F6C6F723A20233241374445413B0D0A7D0D0A0D0A2F2A204945362D382046616C6C6261636B202A2F0D0A406D65646961205C307363';
wwv_flow_imp.g_varchar2_table(6) := '7265656E5C2C73637265656E5C39207B0D0A20202E636865636B626F785F5F69636F6E207B0D0A20202020646973706C61793A206E6F6E653B0D0A20207D0D0A0D0A20202E636865636B626F78203E20696E7075745B747970653D22636865636B626F78';
wwv_flow_imp.g_varchar2_table(7) := '225D207B0D0A20202020706F736974696F6E3A207374617469633B0D0A20207D0D0A7D0D0A2F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0D0A202A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0D0A20';
wwv_flow_imp.g_varchar2_table(8) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0D0A202A2048656C706572730D0A202A2F0D0A2E636865636B626F785F5F69636F6E3A6265666F7265207B0D0A2020666F6E742D66616D696C793A202269636F6E73223B0D0A2020';
wwv_flow_imp.g_varchar2_table(9) := '737065616B3A206E6F6E653B0D0A2020666F6E742D7374796C653A206E6F726D616C3B0D0A2020666F6E742D7765696768743A206E6F726D616C3B0D0A2020666F6E742D76617269616E743A206E6F726D616C3B0D0A2020746578742D7472616E73666F';
wwv_flow_imp.g_varchar2_table(10) := '726D3A206E6F6E653B0D0A20202F2A2042657474657220466F6E742052656E646572696E67203D3D3D3D3D3D3D3D3D3D3D202A2F0D0A20202D7765626B69742D666F6E742D736D6F6F7468696E673A20616E7469616C69617365643B0D0A20202D6D6F7A';
wwv_flow_imp.g_varchar2_table(11) := '2D6F73782D666F6E742D736D6F6F7468696E673A20677261797363616C653B0D0A7D0D0A0D0A2E69636F6E2D2D636865636B3A6265666F72652C20696E7075745B747970653D22636865636B626F78225D3A636865636B6564207E202E636865636B626F';
wwv_flow_imp.g_varchar2_table(12) := '785F5F69636F6E3A6265666F7265207B0D0A2020636F6E74656E743A20225C65363031223B0D0A7D0D0A0D0A2E69636F6E2D2D636865636B2D656D7074793A6265666F72652C202E636865636B626F785F5F69636F6E3A6265666F7265207B0D0A202063';
wwv_flow_imp.g_varchar2_table(13) := '6F6E74656E743A20225C65363030223B0D0A7D0D0A0D0A40666F6E742D66616365207B0D0A2020666F6E742D66616D696C793A202269636F6E73223B0D0A2020666F6E742D7765696768743A206E6F726D616C3B0D0A2020666F6E742D7374796C653A20';
wwv_flow_imp.g_varchar2_table(14) := '6E6F726D616C3B0D0A20207372633A2075726C2822646174613A6170706C69636174696F6E2F782D666F6E742D776F66663B636861727365743D7574662D383B6261736536342C64303947526B3955564538414141523441416F41414141414244414141';
wwv_flow_imp.g_varchar2_table(15) := '41414141414141414141414141414141414141414141414141414141414244526B596741414141394141414150674141414434665A5541564539544C7A494141414873414141415941414141474149497679335932316863414141416B77414141424D41';
wwv_flow_imp.g_varchar2_table(16) := '414141544270567A46686E59584E77414141436D4141414141674141414149414141414547686C5957514141414B67414141414E674141414459416573777A6147686C59514141417467414141416B414141414A4150694165646F62585234414141432F';
wwv_flow_imp.g_varchar2_table(17) := '414141414267414141415942514141414731686548414141414D55414141414267414141415941426C4141626D46745A5141414178774141414535414141424F555159744E5A7762334E304141414557414141414341414141416741414D414141454142';
wwv_flow_imp.g_varchar2_table(18) := '4151414151454243476C6A623231766232344141514941415141362B4277432B4273442B42674548676F414756502F693473654367415A552F2B4C69777748693276346C50683042523041414142384478304141414342455230414141414A4851414141';
wwv_flow_imp.g_varchar2_table(19) := '4F3853414163424151675045524D5747794270593239746232397561574E7662573976626E5577645446314D6A4231525459774D4856464E6A41784141414341596B41424141474151454542776F4E4C3258386C4137386C4137386C4137376C41364C2B';
wwv_flow_imp.g_varchar2_table(20) := '485156692F79552B4A534C692F69552F4A534C42643833466666736934763737507673693476333741554F692F6830465976386C50695569347633337A6333692F73332B2B794C692F6673397A654C33393846397743464666744E2B30354A7A55644939';
wwv_flow_imp.g_varchar2_table(21) := '78723747766552393546487A77554F2B4A51552B4A51566977774B41414D4341414751414155414141464D4157594141414248415577425A6741414150554147514345414141414141414141414141414141414141414141524141414141414141414141';
wwv_flow_imp.g_varchar2_table(22) := '4141414141414141414141514141413567454234502F672F2B414234414167414141414151414141414141414141414141414149414141414141414167414141414D414141415541414D4141514141414251414241413441414141436741494141494141';
wwv_flow_imp.g_varchar2_table(23) := '6741424143446D41662F392F2F3841414141414143446D41502F392F2F384141662F6A4767514141774142414141414141414141414141414141424141482F2F77415041414541414141414141436B59436667587738383951414C41674141414141417A';
wwv_flow_imp.g_varchar2_table(24) := '3635467577414141414450726B57374141442F344149414165414141414149414149414141414141414141415141414165442F34414141416741414141414141674141415141414141414141414141414141414141414141415941414141414141414141';
wwv_flow_imp.g_varchar2_table(25) := '4141414141414241414141416741414141494141414141414641414141594141414141414134417267414241414141414141424141344141414142414141414141414341413441527741424141414141414144414134414A414142414141414141414541';
wwv_flow_imp.g_varchar2_table(26) := '41344156514142414141414141414641425941446741424141414141414147414163414D674142414141414141414B414367415977414441414545435141424141344141414144414145454351414341413441527741444141454543514144414134414A';
wwv_flow_imp.g_varchar2_table(27) := '41414441414545435141454141344156514144414145454351414641425941446741444141454543514147414134414F514144414145454351414B414367415977427041474D41627742744147384162774275414659415A51427941484D416151427641';
wwv_flow_imp.g_varchar2_table(28) := '47344149414178414334414D41427041474D4162774274414738416277427561574E76625739766267427041474D41627742744147384162774275414649415A51426E4148554162414268414849416151426A4147384162514276414738416267424841';
wwv_flow_imp.g_varchar2_table(29) := '4755416267426C4148494159514230414755415A414167414749416551416741456B4159774276414530416277427641473441414141414177414141414141414141414141414141414141414141414141414141414141414141414141414141413D3D22';
wwv_flow_imp.g_varchar2_table(30) := '2920666F726D61742822776F666622293B0D0A7D0D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26538627901826662)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'dat-checkbox.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '40696D706F72742075726C2868747470733A2F2F666F6E74732E676F6F676C65617069732E636F6D2F6373733F66616D696C793D52616C657761793A3430302C3330302C373030293B0A0A0A2E64656D6F207B0A2020646973706C61793A20696E6C696E';
wwv_flow_imp.g_varchar2_table(2) := '652D626C6F636B3B0A202070616464696E673A20353070783B0A20206261636B67726F756E642D636F6C6F723A20236666663B0A2020626F726465722D7261646975733A20323070783B0A2020636F6C6F723A20233636363B0A2020746578742D616C69';
wwv_flow_imp.g_varchar2_table(3) := '676E3A2063656E7465723B0A7D0A0A2E64656D6F5F5F636F6E74656E74207B0A2020746578742D616C69676E3A206C6566743B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A7D0A0A2E64656D6F5F5F7469746C65207B0A2020666F6E';
wwv_flow_imp.g_varchar2_table(4) := '742D73697A653A20353070783B0A2020666F6E742D7765696768743A20626F6C643B0A2020746578742D7472616E73666F726D3A207570706572636173653B0A202070616464696E672D626F74746F6D3A20333070783B0A7D0A0A2E7377697463686572';
wwv_flow_imp.g_varchar2_table(5) := '207B0A2020706F736974696F6E3A2072656C61746976653B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A2020637572736F723A20706F696E7465723B0A202070616464696E672D6C6566743A2031303070783B0A2020686569676874';
wwv_flow_imp.g_varchar2_table(6) := '3A20343070783B0A20206C696E652D6865696768743A20343070783B0A20206D617267696E3A203570783B0A2020666F6E742D73697A653A20333070783B0A20202D7765626B69742D757365722D73656C6563743A206E6F6E653B0A20202020202D6D6F';
wwv_flow_imp.g_varchar2_table(7) := '7A2D757365722D73656C6563743A206E6F6E653B0A2020202020202D6D732D757365722D73656C6563743A206E6F6E653B0A20202020202020202020757365722D73656C6563743A206E6F6E653B0A7D0A2E737769746368657220696E707574207B0A20';
wwv_flow_imp.g_varchar2_table(8) := '20646973706C61793A206E6F6E653B0A7D0A0A2E73776974636865725F5F696E64696361746F723A3A6166746572207B0A2020636F6E74656E743A2022223B0A2020706F736974696F6E3A206162736F6C7574653B0A2020746F703A20303B0A20206C65';
wwv_flow_imp.g_varchar2_table(9) := '66743A20303B0A20206865696768743A20343070783B0A202077696474683A20343070783B0A20206261636B67726F756E642D636F6C6F723A20236435643564353B0A2020626F726465722D7261646975733A203530253B0A20207472616E736974696F';
wwv_flow_imp.g_varchar2_table(10) := '6E3A20616C6C20302E337320656173653B0A20202D7765626B69742D616E696D6174696F6E2D6E616D653A2070756C7365696E3B0A20202020202020202020616E696D6174696F6E2D6E616D653A2070756C7365696E3B0A20202D7765626B69742D616E';
wwv_flow_imp.g_varchar2_table(11) := '696D6174696F6E2D6475726174696F6E3A20302E33733B0A20202020202020202020616E696D6174696F6E2D6475726174696F6E3A20302E33733B0A7D0A2E73776974636865725F5F696E64696361746F723A3A6265666F7265207B0A2020636F6E7465';
wwv_flow_imp.g_varchar2_table(12) := '6E743A2022223B0A2020706F736974696F6E3A206162736F6C7574653B0A2020746F703A20313670783B0A20206C6566743A20303B0A202077696474683A20383070783B0A20206865696768743A203870783B0A20206261636B67726F756E642D636F6C';
wwv_flow_imp.g_varchar2_table(13) := '6F723A20236435643564353B0A2020626F726465722D7261646975733A20313070783B0A20207472616E736974696F6E3A20616C6C20302E337320656173653B0A7D0A696E7075743A636865636B6564202B202E73776974636865725F5F696E64696361';
wwv_flow_imp.g_varchar2_table(14) := '746F723A3A6166746572207B0A20206261636B67726F756E642D636F6C6F723A20233239636539613B0A20207472616E73666F726D3A207472616E736C617465582834307078293B0A20202D7765626B69742D616E696D6174696F6E2D6E616D653A2070';
wwv_flow_imp.g_varchar2_table(15) := '756C73656F75743B0A20202020202020202020616E696D6174696F6E2D6E616D653A2070756C73656F75743B0A20202D7765626B69742D616E696D6174696F6E2D6475726174696F6E3A20302E33733B0A20202020202020202020616E696D6174696F6E';
wwv_flow_imp.g_varchar2_table(16) := '2D6475726174696F6E3A20302E33733B0A7D0A696E7075743A636865636B6564202B202E73776974636865725F5F696E64696361746F723A3A6265666F7265207B0A20206261636B67726F756E642D636F6C6F723A20233239636539613B0A7D0A696E70';
wwv_flow_imp.g_varchar2_table(17) := '75743A64697361626C6564202B202E73776974636865725F5F696E64696361746F723A3A61667465722C20696E7075743A64697361626C6564202B202E73776974636865725F5F696E64696361746F723A3A6265666F7265207B0A20206261636B67726F';
wwv_flow_imp.g_varchar2_table(18) := '756E642D636F6C6F723A20236535653565353B0A7D0A0A402D7765626B69742D6B65796672616D65732070756C7365696E207B0A202030252C2031303025207B0A20202020746F703A203070783B0A202020206865696768743A20343070783B0A202020';
wwv_flow_imp.g_varchar2_table(19) := '2077696474683A20343070783B0A20207D0A2020353025207B0A20202020746F703A203670783B0A202020206865696768743A20323870783B0A2020202077696474683A20353270783B0A20207D0A7D0A0A406B65796672616D65732070756C7365696E';
wwv_flow_imp.g_varchar2_table(20) := '207B0A202030252C2031303025207B0A20202020746F703A203070783B0A202020206865696768743A20343070783B0A2020202077696474683A20343070783B0A20207D0A2020353025207B0A20202020746F703A203670783B0A202020206865696768';
wwv_flow_imp.g_varchar2_table(21) := '743A20323870783B0A2020202077696474683A20353270783B0A20207D0A7D0A402D7765626B69742D6B65796672616D65732070756C73656F7574207B0A202030252C2031303025207B0A20202020746F703A203070783B0A202020206865696768743A';
wwv_flow_imp.g_varchar2_table(22) := '20343070783B0A2020202077696474683A20343070783B0A20207D0A2020353025207B0A20202020746F703A203670783B0A202020206865696768743A20323870783B0A2020202077696474683A20353270783B0A20207D0A7D0A406B65796672616D65';
wwv_flow_imp.g_varchar2_table(23) := '732070756C73656F7574207B0A202030252C2031303025207B0A20202020746F703A203070783B0A202020206865696768743A20343070783B0A2020202077696474683A20343070783B0A20207D0A2020353025207B0A20202020746F703A203670783B';
wwv_flow_imp.g_varchar2_table(24) := '0A202020206865696768743A20323870783B0A2020202077696474683A20353270783B0A20207D0A7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26548284119895379)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'fluid-checkbox.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E7569737769746368207B0D0A20202D7765626B69742D626F782D73697A696E673A20626F726465722D626F783B0D0A20202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B0D0A2020626F782D73697A696E673A20626F72646572';
wwv_flow_imp.g_varchar2_table(2) := '2D626F783B0D0A20202D7765626B69742D617070656172616E63653A206E6F6E653B0D0A20202D6D6F7A2D617070656172616E63653A206E6F6E653B0D0A20202D6D732D617070656172616E63653A206E6F6E653B0D0A20202D6F2D617070656172616E';
wwv_flow_imp.g_varchar2_table(3) := '63653A206E6F6E653B0D0A2020617070656172616E63653A206E6F6E653B0D0A20202D7765626B69742D757365722D73656C6563743A206E6F6E653B0D0A20202D6D6F7A2D757365722D73656C6563743A206E6F6E653B0D0A20202D6D732D757365722D';
wwv_flow_imp.g_varchar2_table(4) := '73656C6563743A206E6F6E653B0D0A2020757365722D73656C6563743A206E6F6E653B0D0A20206865696768743A20333170783B0D0A202077696474683A20353170783B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A2020626F726465';
wwv_flow_imp.g_varchar2_table(5) := '722D7261646975733A20313670783B0D0A2020637572736F723A20706F696E7465723B0D0A20206F75746C696E653A20303B0D0A20207A2D696E6465783A20303B0D0A20206D617267696E3A20303B0D0A202070616464696E673A20303B0D0A2020626F';
wwv_flow_imp.g_varchar2_table(6) := '726465723A206E6F6E653B0D0A20206261636B67726F756E642D636F6C6F723A20236535653565353B0D0A20202D7765626B69742D7472616E736974696F6E2D6475726174696F6E3A203630306D733B0D0A20202D6D6F7A2D7472616E736974696F6E2D';
wwv_flow_imp.g_varchar2_table(7) := '6475726174696F6E3A203630306D733B0D0A20207472616E736974696F6E2D6475726174696F6E3A203630306D733B0D0A20202D7765626B69742D7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A20656173652D696E2D6F75743B0D';
wwv_flow_imp.g_varchar2_table(8) := '0A20202D6D6F7A2D7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A20656173652D696E2D6F75743B0D0A20207472616E736974696F6E2D74696D696E672D66756E6374696F6E3A20656173652D696E2D6F75743B0D0A20202D776562';
wwv_flow_imp.g_varchar2_table(9) := '6B69742D746F7563682D63616C6C6F75743A206E6F6E653B0D0A20202D7765626B69742D746578742D73697A652D61646A7573743A206E6F6E653B0D0A20202D7765626B69742D7461702D686967686C696768742D636F6C6F723A207267626128302C20';
wwv_flow_imp.g_varchar2_table(10) := '302C20302C2030293B0D0A20202D7765626B69742D757365722D73656C6563743A206E6F6E653B0D0A7D0D0A2E75697377697463683A3A6265666F7265207B0D0A20202D7765626B69742D626F782D73697A696E673A20626F726465722D626F783B0D0A';
wwv_flow_imp.g_varchar2_table(11) := '20202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B0D0A2020626F782D73697A696E673A20626F726465722D626F783B0D0A20206865696768743A20323770783B0D0A202077696474683A20343770783B0D0A2020636F6E74656E';
wwv_flow_imp.g_varchar2_table(12) := '743A202220223B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A20206C6566743A203270783B0D0A2020746F703A203270783B0D0A2020626F726465722D7261646975733A20313670783B0D0A20207A2D696E6465783A20313B0D0A2020';
wwv_flow_imp.g_varchar2_table(13) := '2D7765626B69742D7472616E736974696F6E2D6475726174696F6E3A203330306D733B0D0A20202D6D6F7A2D7472616E736974696F6E2D6475726174696F6E3A203330306D733B0D0A20207472616E736974696F6E2D6475726174696F6E3A203330306D';
wwv_flow_imp.g_varchar2_table(14) := '733B0D0A20202D7765626B69742D7472616E73666F726D3A207363616C652831293B0D0A20202D6D6F7A2D7472616E73666F726D3A207363616C652831293B0D0A20202D6D732D7472616E73666F726D3A207363616C652831293B0D0A20202D6F2D7472';
wwv_flow_imp.g_varchar2_table(15) := '616E73666F726D3A207363616C652831293B0D0A20207472616E73666F726D3A207363616C652831293B0D0A7D0D0A2E75697377697463683A3A6166746572207B0D0A20202D7765626B69742D626F782D73697A696E673A20626F726465722D626F783B';
wwv_flow_imp.g_varchar2_table(16) := '0D0A20202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B0D0A2020626F782D73697A696E673A20626F726465722D626F783B0D0A20206865696768743A20323770783B0D0A202077696474683A20323770783B0D0A2020636F6E74';
wwv_flow_imp.g_varchar2_table(17) := '656E743A202220223B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A2020626F726465722D7261646975733A20323770783B0D0A20206261636B67726F756E643A20236666666666663B0D0A20207A2D696E6465783A20323B0D0A202074';
wwv_flow_imp.g_varchar2_table(18) := '6F703A203270783B0D0A20206C6566743A203270783B0D0A2020626F782D736861646F773A20307078203070782031707820307078207267626128302C20302C20302C20302E3235292C2030707820347078203131707820307078207267626128302C20';
wwv_flow_imp.g_varchar2_table(19) := '302C20302C20302E3038292C202D317078203370782033707820307078207267626128302C20302C20302C20302E3134293B0D0A20202D7765626B69742D7472616E736974696F6E3A202D7765626B69742D7472616E73666F726D203330306D732C2077';
wwv_flow_imp.g_varchar2_table(20) := '69647468203238306D733B0D0A20202D6D6F7A2D7472616E736974696F6E3A202D6D6F7A2D7472616E73666F726D203330306D732C207769647468203238306D733B0D0A20207472616E736974696F6E3A207472616E73666F726D203330306D732C2077';
wwv_flow_imp.g_varchar2_table(21) := '69647468203238306D733B0D0A20202D7765626B69742D7472616E73666F726D3A207472616E736C617465336428302C20302C2030293B0D0A20202D6D6F7A2D7472616E73666F726D3A207472616E736C617465336428302C20302C2030293B0D0A2020';
wwv_flow_imp.g_varchar2_table(22) := '2D6D732D7472616E73666F726D3A207472616E736C617465336428302C20302C2030293B0D0A20202D6F2D7472616E73666F726D3A207472616E736C617465336428302C20302C2030293B0D0A20207472616E73666F726D3A207472616E736C61746533';
wwv_flow_imp.g_varchar2_table(23) := '6428302C20302C2030293B0D0A20202D7765626B69742D7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A2063756269632D62657A69657228302E34322C20302E382C20302E35382C20312E32293B0D0A20202D6D6F7A2D7472616E73';
wwv_flow_imp.g_varchar2_table(24) := '6974696F6E2D74696D696E672D66756E6374696F6E3A2063756269632D62657A69657228302E34322C20302E382C20302E35382C20312E32293B0D0A20207472616E736974696F6E2D74696D696E672D66756E6374696F6E3A2063756269632D62657A69';
wwv_flow_imp.g_varchar2_table(25) := '657228302E34322C20302E382C20302E35382C20312E32293B0D0A7D0D0A2E75697377697463683A636865636B6564207B0D0A20206261636B67726F756E642D636F6C6F723A20233443443936343B0D0A20206261636B67726F756E642D696D6167653A';
wwv_flow_imp.g_varchar2_table(26) := '202D7765626B69742D6C696E6561722D6772616469656E74282D39306465672C20233443443936342030252C20233464643836352031303025293B0D0A20206261636B67726F756E642D696D6167653A206C696E6561722D6772616469656E74282D3138';
wwv_flow_imp.g_varchar2_table(27) := '306465672C233443443936342030252C20233464643836352031303025293B0D0A7D0D0A2E75697377697463683A636865636B65643A3A6166746572207B0D0A20202D7765626B69742D7472616E73666F726D3A207472616E736C617465336428313670';
wwv_flow_imp.g_varchar2_table(28) := '782C20302C2030293B0D0A20202D6D6F7A2D7472616E73666F726D3A207472616E736C617465336428313670782C20302C2030293B0D0A20202D6D732D7472616E73666F726D3A207472616E736C617465336428313670782C20302C2030293B0D0A2020';
wwv_flow_imp.g_varchar2_table(29) := '2D6F2D7472616E73666F726D3A207472616E736C617465336428313670782C20302C2030293B0D0A20207472616E73666F726D3A207472616E736C617465336428313670782C20302C2030293B0D0A202072696768743A20313870783B0D0A20206C6566';
wwv_flow_imp.g_varchar2_table(30) := '743A20696E68657269743B0D0A7D0D0A2E75697377697463683A6163746976653A3A6166746572207B0D0A202077696474683A20333570783B0D0A7D0D0A2E75697377697463683A636865636B65643A3A6265666F72652C202E75697377697463683A61';
wwv_flow_imp.g_varchar2_table(31) := '63746976653A3A6265666F7265207B0D0A20202D7765626B69742D7472616E73666F726D3A207363616C652830293B0D0A20202D6D6F7A2D7472616E73666F726D3A207363616C652830293B0D0A20202D6D732D7472616E73666F726D3A207363616C65';
wwv_flow_imp.g_varchar2_table(32) := '2830293B0D0A20202D6F2D7472616E73666F726D3A207363616C652830293B0D0A20207472616E73666F726D3A207363616C652830293B0D0A7D0D0A2E75697377697463683A64697361626C6564207B0D0A20206F7061636974793A20302E353B0D0A20';
wwv_flow_imp.g_varchar2_table(33) := '20637572736F723A2064656661756C743B0D0A20202D7765626B69742D7472616E736974696F6E3A206E6F6E653B0D0A20202D6D6F7A2D7472616E736974696F6E3A206E6F6E653B0D0A20207472616E736974696F6E3A206E6F6E653B0D0A7D0D0A2E75';
wwv_flow_imp.g_varchar2_table(34) := '697377697463683A64697361626C65643A6163746976653A3A6265666F72652C202E75697377697463683A64697361626C65643A6163746976653A3A61667465722C202E75697377697463683A64697361626C65643A636865636B65643A3A6265666F72';
wwv_flow_imp.g_varchar2_table(35) := '65207B0D0A202077696474683A20323770783B0D0A20202D7765626B69742D7472616E736974696F6E3A206E6F6E653B0D0A20202D6D6F7A2D7472616E736974696F6E3A206E6F6E653B0D0A20207472616E736974696F6E3A206E6F6E653B0D0A7D0D0A';
wwv_flow_imp.g_varchar2_table(36) := '2E75697377697463683A64697361626C65643A6163746976653A3A6265666F7265207B0D0A20206865696768743A20323770783B0D0A202077696474683A20343170783B0D0A20202D7765626B69742D7472616E73666F726D3A207472616E736C617465';
wwv_flow_imp.g_varchar2_table(37) := '3364283670782C20302C2030293B0D0A20202D6D6F7A2D7472616E73666F726D3A207472616E736C6174653364283670782C20302C2030293B0D0A20202D6D732D7472616E73666F726D3A207472616E736C6174653364283670782C20302C2030293B0D';
wwv_flow_imp.g_varchar2_table(38) := '0A20202D6F2D7472616E73666F726D3A207472616E736C6174653364283670782C20302C2030293B0D0A20207472616E73666F726D3A207472616E736C6174653364283670782C20302C2030293B0D0A7D0D0A2E75697377697463683A64697361626C65';
wwv_flow_imp.g_varchar2_table(39) := '643A636865636B65643A6163746976653A3A6265666F7265207B0D0A20206865696768743A20323770783B0D0A202077696474683A20323770783B0D0A20202D7765626B69742D7472616E73666F726D3A207363616C652830293B0D0A20202D6D6F7A2D';
wwv_flow_imp.g_varchar2_table(40) := '7472616E73666F726D3A207363616C652830293B0D0A20202D6D732D7472616E73666F726D3A207363616C652830293B0D0A20202D6F2D7472616E73666F726D3A207363616C652830293B0D0A20207472616E73666F726D3A207363616C652830293B0D';
wwv_flow_imp.g_varchar2_table(41) := '0A7D0D0A0D0A2E7569737769746368207B0D0A20206261636B67726F756E642D636F6C6F723A20236535653565353B0D0A7D0D0A0D0A0D0A2E75697377697463683A636865636B6564207B0D0A20206261636B67726F756E642D636F6C6F723A20233443';
wwv_flow_imp.g_varchar2_table(42) := '443936343B0D0A20206261636B67726F756E642D696D6167653A202D7765626B69742D6C696E6561722D6772616469656E74282D39306465672C20233443443936342030252C20233464643836352031303025293B0D0A20206261636B67726F756E642D';
wwv_flow_imp.g_varchar2_table(43) := '696D6167653A206C696E6561722D6772616469656E74282D3138306465672C233443443936342030252C20233464643836352031303025293B0D0A7D0D0A0D0A0D0A0D0A2E77726170706572207B0D0A202077696474683A203930253B0D0A20206D6172';
wwv_flow_imp.g_varchar2_table(44) := '67696E3A2030206175746F3B0D0A2020746578742D616C69676E3A2063656E7465723B0D0A7D0D0A0D0A0D0A0D0A2E6669656C64735F5F6974656D207B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A20206D617267696E2D7269';
wwv_flow_imp.g_varchar2_table(45) := '6768743A20312E383735656D3B0D0A2020746578742D616C69676E3A2063656E7465723B0D0A7D0D0A0D0A0D0A2E73656374696F6E207B0D0A20206D617267696E3A2032656D206175746F3B0D0A7D0D0A0D0A2E637573746F6D207B0D0A20206261636B';
wwv_flow_imp.g_varchar2_table(46) := '67726F756E642D636F6C6F723A20236561646362633B0D0A7D0D0A0D0A2E637573746F6D3A3A6265666F7265207B0D0A20206261636B67726F756E642D636F6C6F723A20236637663265353B0D0A7D0D0A0D0A2E637573746F6D3A3A6166746572207B0D';
wwv_flow_imp.g_varchar2_table(47) := '0A20206261636B67726F756E643A20236666663361363B0D0A7D0D0A0D0A2E637573746F6D3A636865636B6564207B0D0A20206261636B67726F756E642D636F6C6F723A20236666636133663B0D0A20206261636B67726F756E642D696D6167653A202D';
wwv_flow_imp.g_varchar2_table(48) := '7765626B69742D6C696E6561722D6772616469656E74282D39306465672C20236666636133662030252C20236665636134302031303025293B0D0A20206261636B67726F756E642D696D6167653A206C696E6561722D6772616469656E74282D31383064';
wwv_flow_imp.g_varchar2_table(49) := '65672C20236666636133662030252C20236665636134302031303025293B0D0A7D0D0A0D0A2E6D792D737769746368207B0D0A2020626F726465722D7261646975733A203470783B0D0A7D0D0A0D0A2E6D792D7377697463683A3A6265666F7265207B0D';
wwv_flow_imp.g_varchar2_table(50) := '0A2020626F726465722D7261646975733A203270783B0D0A7D0D0A0D0A2E6D792D7377697463683A3A6166746572207B0D0A2020626F726465722D7261646975733A203170783B0D0A7D0D0A0D0A2E6D792D7377697463683A636865636B6564207B0D0A';
wwv_flow_imp.g_varchar2_table(51) := '20206261636B67726F756E643A20686F7470696E6B3B0D0A7D0D0A0D0A2E6D792D7377697463683A636865636B65643A3A6166746572207B0D0A20206261636B67726F756E642D636F6C6F723A20233333333B0D0A7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26551728046852661)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'clean.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '402D7765626B69742D6B65796672616D657320736C69646555707B30257B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655928362E323572656D293B7472616E73666F726D3A7472616E736C6174655928362E323572656D297D746F';
wwv_flow_imp.g_varchar2_table(2) := '7B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592830293B7472616E73666F726D3A7472616E736C617465592830297D7D406B65796672616D657320736C69646555707B30257B2D7765626B69742D7472616E73666F726D3A7472';
wwv_flow_imp.g_varchar2_table(3) := '616E736C6174655928362E323572656D293B7472616E73666F726D3A7472616E736C6174655928362E323572656D297D746F7B2D7765626B69742D7472616E73666F726D3A7472616E736C617465592830293B7472616E73666F726D3A7472616E736C61';
wwv_flow_imp.g_varchar2_table(4) := '7465592830297D7D2E6C6162656C2D2D636865636B626F787B706F736974696F6E3A72656C61746976653B6D617267696E3A2E3572656D3B666F6E742D66616D696C793A417269616C2C73616E732D73657269663B6C696E652D6865696768743A313335';
wwv_flow_imp.g_varchar2_table(5) := '253B637572736F723A706F696E7465727D2E6D6174657269616C2D636865636B626F787B706F736974696F6E3A72656C61746976653B746F703A2D2E33373572656D3B6D617267696E3A30203172656D203020303B637572736F723A706F696E7465727D';
wwv_flow_imp.g_varchar2_table(6) := '2E6D6174657269616C2D636865636B626F783A6265666F72657B2D7765626B69742D7472616E736974696F6E3A616C6C202E337320656173652D696E2D6F75743B2D6D6F7A2D7472616E736974696F6E3A616C6C202E337320656173652D696E2D6F7574';
wwv_flow_imp.g_varchar2_table(7) := '3B7472616E736974696F6E3A616C6C202E337320656173652D696E2D6F75743B636F6E74656E743A22223B706F736974696F6E3A6162736F6C7574653B6C6566743A303B7A2D696E6465783A313B77696474683A3172656D3B6865696768743A3172656D';
wwv_flow_imp.g_varchar2_table(8) := '3B626F726465723A32707820736F6C696420236632663266327D2E6D6174657269616C2D636865636B626F783A636865636B65643A6265666F72657B2D7765626B69742D7472616E73666F726D3A726F74617465282D3435646567293B2D6D6F7A2D7472';
wwv_flow_imp.g_varchar2_table(9) := '616E73666F726D3A726F74617465282D3435646567293B2D6D732D7472616E73666F726D3A726F74617465282D3435646567293B2D6F2D7472616E73666F726D3A726F74617465282D3435646567293B7472616E73666F726D3A726F74617465282D3435';
wwv_flow_imp.g_varchar2_table(10) := '646567293B6865696768743A2E3572656D3B626F726465722D636F6C6F723A233030393638383B626F726465722D746F702D7374796C653A6E6F6E653B626F726465722D72696768742D7374796C653A6E6F6E657D2E6D6174657269616C2D636865636B';
wwv_flow_imp.g_varchar2_table(11) := '626F783A61667465727B636F6E74656E743A22223B706F736974696F6E3A6162736F6C7574653B746F703A2D2E31323572656D3B6C6566743A303B77696474683A312E3172656D3B6865696768743A312E3172656D3B6261636B67726F756E643A236666';
wwv_flow_imp.g_varchar2_table(12) := '663B637572736F723A706F696E7465727D2E627574746F6E2D2D726F756E647B2D7765626B69742D7472616E736974696F6E3A2E3373206261636B67726F756E6420656173652D696E2D6F75743B2D6D6F7A2D7472616E736974696F6E3A2E3373206261';
wwv_flow_imp.g_varchar2_table(13) := '636B67726F756E6420656173652D696E2D6F75743B7472616E736974696F6E3A2E3373206261636B67726F756E6420656173652D696E2D6F75743B77696474683A3272656D3B6865696768743A3272656D3B6261636B67726F756E643A23353637376663';
wwv_flow_imp.g_varchar2_table(14) := '3B626F726465722D7261646975733A3530253B626F782D736861646F773A30202E31323572656D202E3331323572656D2030207267626128302C302C302C2E3235293B636F6C6F723A236666663B746578742D6465636F726174696F6E3A6E6F6E653B74';
wwv_flow_imp.g_varchar2_table(15) := '6578742D616C69676E3A63656E7465727D2E627574746F6E2D2D726F756E6420697B666F6E742D73697A653A3172656D3B6C696E652D6865696768743A323230253B766572746963616C2D616C69676E3A6D6964646C657D2E627574746F6E2D2D726F75';
wwv_flow_imp.g_varchar2_table(16) := '6E643A686F7665727B6261636B67726F756E643A233362353063657D2E627574746F6E2D2D737469636B797B706F736974696F6E3A66697865643B72696768743A3272656D3B746F703A313672656D7D2E636F6E74656E747B2D7765626B69742D616E69';
wwv_flow_imp.g_varchar2_table(17) := '6D6174696F6E2D6475726174696F6E3A2E34733B616E696D6174696F6E2D6475726174696F6E3A2E34733B2D7765626B69742D616E696D6174696F6E2D66696C6C2D6D6F64653A626F74683B616E696D6174696F6E2D66696C6C2D6D6F64653A626F7468';
wwv_flow_imp.g_varchar2_table(18) := '3B2D7765626B69742D616E696D6174696F6E2D6E616D653A736C69646555703B616E696D6174696F6E2D6E616D653A736C69646555703B2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A63756269632D62657A6965';
wwv_flow_imp.g_varchar2_table(19) := '72282E342C302C2E322C31293B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A63756269632D62657A696572282E342C302C2E322C31297D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26627721389311358)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'material-checkbox.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E75697377697463682C2E75697377697463683A3A61667465722C2E75697377697463683A3A6265666F72657B2D7765626B69742D626F782D73697A696E673A626F726465722D626F783B2D6D6F7A2D626F782D73697A696E673A626F726465722D626F';
wwv_flow_imp.g_varchar2_table(2) := '783B626F782D73697A696E673A626F726465722D626F787D2E75697377697463687B2D7765626B69742D617070656172616E63653A6E6F6E653B2D6D6F7A2D617070656172616E63653A6E6F6E653B2D6D732D617070656172616E63653A6E6F6E653B2D';
wwv_flow_imp.g_varchar2_table(3) := '6F2D617070656172616E63653A6E6F6E653B617070656172616E63653A6E6F6E653B2D6D6F7A2D757365722D73656C6563743A6E6F6E653B2D6D732D757365722D73656C6563743A6E6F6E653B757365722D73656C6563743A6E6F6E653B686569676874';
wwv_flow_imp.g_varchar2_table(4) := '3A333170783B77696474683A353170783B706F736974696F6E3A72656C61746976653B626F726465722D7261646975733A313670783B637572736F723A706F696E7465723B6F75746C696E653A303B7A2D696E6465783A303B6D617267696E3A303B7061';
wwv_flow_imp.g_varchar2_table(5) := '6464696E673A303B626F726465723A303B2D7765626B69742D7472616E736974696F6E2D6475726174696F6E3A3630306D733B2D6D6F7A2D7472616E736974696F6E2D6475726174696F6E3A3630306D733B7472616E736974696F6E2D6475726174696F';
wwv_flow_imp.g_varchar2_table(6) := '6E3A3630306D733B2D7765626B69742D7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E2D6F75743B2D6D6F7A2D7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E2D6F75743B74';
wwv_flow_imp.g_varchar2_table(7) := '72616E736974696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E2D6F75743B2D7765626B69742D746F7563682D63616C6C6F75743A6E6F6E653B2D7765626B69742D746578742D73697A652D61646A7573743A6E6F6E653B2D7765626B';
wwv_flow_imp.g_varchar2_table(8) := '69742D7461702D686967686C696768742D636F6C6F723A7472616E73706172656E743B2D7765626B69742D757365722D73656C6563743A6E6F6E653B6261636B67726F756E642D636F6C6F723A236535653565357D2E75697377697463683A3A61667465';
wwv_flow_imp.g_varchar2_table(9) := '722C2E75697377697463683A3A6265666F72657B6865696768743A323770783B636F6E74656E743A2220223B706F736974696F6E3A6162736F6C7574653B746F703A3270783B6C6566743A3270787D2E75697377697463683A3A6265666F72657B776964';
wwv_flow_imp.g_varchar2_table(10) := '74683A343770783B626F726465722D7261646975733A313670783B7A2D696E6465783A313B2D7765626B69742D7472616E736974696F6E2D6475726174696F6E3A3330306D733B2D6D6F7A2D7472616E736974696F6E2D6475726174696F6E3A3330306D';
wwv_flow_imp.g_varchar2_table(11) := '733B7472616E736974696F6E2D6475726174696F6E3A3330306D733B2D7765626B69742D7472616E73666F726D3A7363616C652831293B2D6D6F7A2D7472616E73666F726D3A7363616C652831293B2D6D732D7472616E73666F726D3A7363616C652831';
wwv_flow_imp.g_varchar2_table(12) := '293B2D6F2D7472616E73666F726D3A7363616C652831293B7472616E73666F726D3A7363616C652831297D2E75697377697463683A3A61667465727B77696474683A323770783B626F726465722D7261646975733A323770783B6261636B67726F756E64';
wwv_flow_imp.g_varchar2_table(13) := '3A236666663B7A2D696E6465783A323B626F782D736861646F773A302030203170782030207267626128302C302C302C2E3235292C302034707820313170782030207267626128302C302C302C2E3038292C2D3170782033707820337078203020726762';
wwv_flow_imp.g_varchar2_table(14) := '6128302C302C302C2E3134293B2D7765626B69742D7472616E736974696F6E3A2D7765626B69742D7472616E73666F726D203330306D732C7769647468203238306D733B2D6D6F7A2D7472616E736974696F6E3A2D6D6F7A2D7472616E73666F726D2033';
wwv_flow_imp.g_varchar2_table(15) := '30306D732C7769647468203238306D733B7472616E736974696F6E3A7472616E73666F726D203330306D732C7769647468203238306D733B2D7765626B69742D7472616E73666F726D3A7472616E736C617465336428302C302C30293B2D6D6F7A2D7472';
wwv_flow_imp.g_varchar2_table(16) := '616E73666F726D3A7472616E736C617465336428302C302C30293B2D6D732D7472616E73666F726D3A7472616E736C617465336428302C302C30293B2D6F2D7472616E73666F726D3A7472616E736C617465336428302C302C30293B7472616E73666F72';
wwv_flow_imp.g_varchar2_table(17) := '6D3A7472616E736C617465336428302C302C30293B2D7765626B69742D7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A63756269632D62657A696572282E34322C2E382C2E35382C312E32293B2D6D6F7A2D7472616E736974696F6E';
wwv_flow_imp.g_varchar2_table(18) := '2D74696D696E672D66756E6374696F6E3A63756269632D62657A696572282E34322C2E382C2E35382C312E32293B7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A63756269632D62657A696572282E34322C2E382C2E35382C312E32';
wwv_flow_imp.g_varchar2_table(19) := '297D2E75697377697463683A636865636B65643A3A61667465727B2D7765626B69742D7472616E73666F726D3A7472616E736C617465336428313670782C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C617465336428313670782C30';
wwv_flow_imp.g_varchar2_table(20) := '2C30293B2D6D732D7472616E73666F726D3A7472616E736C617465336428313670782C302C30293B2D6F2D7472616E73666F726D3A7472616E736C617465336428313670782C302C30293B7472616E73666F726D3A7472616E736C617465336428313670';
wwv_flow_imp.g_varchar2_table(21) := '782C302C30293B72696768743A313870783B6C6566743A696E68657269747D2E75697377697463683A6163746976653A3A61667465727B77696474683A333570787D2E75697377697463683A6163746976653A3A6265666F72652C2E7569737769746368';
wwv_flow_imp.g_varchar2_table(22) := '3A636865636B65643A3A6265666F72657B2D7765626B69742D7472616E73666F726D3A7363616C652830293B2D6D6F7A2D7472616E73666F726D3A7363616C652830293B2D6D732D7472616E73666F726D3A7363616C652830293B2D6F2D7472616E7366';
wwv_flow_imp.g_varchar2_table(23) := '6F726D3A7363616C652830293B7472616E73666F726D3A7363616C652830297D2E75697377697463683A64697361626C65647B6F7061636974793A2E353B637572736F723A64656661756C743B2D7765626B69742D7472616E736974696F6E3A6E6F6E65';
wwv_flow_imp.g_varchar2_table(24) := '3B2D6D6F7A2D7472616E736974696F6E3A6E6F6E653B7472616E736974696F6E3A6E6F6E657D2E75697377697463683A64697361626C65643A6163746976653A3A61667465722C2E75697377697463683A64697361626C65643A6163746976653A3A6265';
wwv_flow_imp.g_varchar2_table(25) := '666F72652C2E75697377697463683A64697361626C65643A636865636B65643A3A6265666F72657B77696474683A323770783B2D7765626B69742D7472616E736974696F6E3A6E6F6E653B2D6D6F7A2D7472616E736974696F6E3A6E6F6E653B7472616E';
wwv_flow_imp.g_varchar2_table(26) := '736974696F6E3A6E6F6E657D2E75697377697463683A64697361626C65643A6163746976653A3A6265666F72657B6865696768743A323770783B77696474683A343170783B2D7765626B69742D7472616E73666F726D3A7472616E736C61746533642836';
wwv_flow_imp.g_varchar2_table(27) := '70782C302C30293B2D6D6F7A2D7472616E73666F726D3A7472616E736C6174653364283670782C302C30293B2D6D732D7472616E73666F726D3A7472616E736C6174653364283670782C302C30293B2D6F2D7472616E73666F726D3A7472616E736C6174';
wwv_flow_imp.g_varchar2_table(28) := '653364283670782C302C30293B7472616E73666F726D3A7472616E736C6174653364283670782C302C30297D2E75697377697463683A64697361626C65643A636865636B65643A6163746976653A3A6265666F72657B6865696768743A323770783B7769';
wwv_flow_imp.g_varchar2_table(29) := '6474683A323770783B2D7765626B69742D7472616E73666F726D3A7363616C652830293B2D6D6F7A2D7472616E73666F726D3A7363616C652830293B2D6D732D7472616E73666F726D3A7363616C652830293B2D6F2D7472616E73666F726D3A7363616C';
wwv_flow_imp.g_varchar2_table(30) := '652830293B7472616E73666F726D3A7363616C652830297D2E75697377697463683A636865636B65647B6261636B67726F756E642D636F6C6F723A233463643936343B6261636B67726F756E642D696D6167653A2D7765626B69742D6C696E6561722D67';
wwv_flow_imp.g_varchar2_table(31) := '72616469656E74282D39306465672C2334636439363420302C233464643836352031303025293B6261636B67726F756E642D696D6167653A6C696E6561722D6772616469656E74282D3138306465672C2334636439363420302C23346464383635203130';
wwv_flow_imp.g_varchar2_table(32) := '3025297D2E777261707065727B77696474683A3930253B6D617267696E3A30206175746F3B746578742D616C69676E3A63656E7465727D2E6669656C64735F5F6974656D7B646973706C61793A696E6C696E652D626C6F636B3B6D617267696E2D726967';
wwv_flow_imp.g_varchar2_table(33) := '68743A312E383735656D3B746578742D616C69676E3A63656E7465727D2E73656374696F6E7B6D617267696E3A32656D206175746F7D2E637573746F6D7B6261636B67726F756E642D636F6C6F723A236561646362637D2E637573746F6D3A3A6265666F';
wwv_flow_imp.g_varchar2_table(34) := '72657B6261636B67726F756E642D636F6C6F723A236637663265357D2E637573746F6D3A3A61667465727B6261636B67726F756E643A236666663361367D2E637573746F6D3A636865636B65647B6261636B67726F756E642D636F6C6F723A2366666361';
wwv_flow_imp.g_varchar2_table(35) := '33663B6261636B67726F756E642D696D6167653A2D7765626B69742D6C696E6561722D6772616469656E74282D39306465672C2366666361336620302C236665636134302031303025293B6261636B67726F756E642D696D6167653A6C696E6561722D67';
wwv_flow_imp.g_varchar2_table(36) := '72616469656E74282D3138306465672C2366666361336620302C236665636134302031303025297D2E6D792D7377697463687B626F726465722D7261646975733A3470787D2E6D792D7377697463683A3A6265666F72657B626F726465722D7261646975';
wwv_flow_imp.g_varchar2_table(37) := '733A3270787D2E6D792D7377697463683A3A61667465727B626F726465722D7261646975733A3170787D2E6D792D7377697463683A636865636B65647B6261636B67726F756E643A236666363962347D2E6D792D7377697463683A636865636B65643A3A';
wwv_flow_imp.g_varchar2_table(38) := '61667465727B6261636B67726F756E642D636F6C6F723A233333337D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26640398535407843)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'clean.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '40696D706F72742075726C2868747470733A2F2F666F6E74732E676F6F676C65617069732E636F6D2F6373733F66616D696C793D517569636B73616E643A3430302C37303026646973706C61793D73776170293B2E626F787B77696474683A3330307078';
wwv_flow_imp.g_varchar2_table(2) := '3B6D617267696E3A3235707820303B646973706C61793A666C65783B616C69676E2D6974656D733A63656E7465723B757365722D73656C6563743A6E6F6E657D2E626F78206C6162656C7B666F6E742D73697A653A323670783B636F6C6F723A23346434';
wwv_flow_imp.g_varchar2_table(3) := '6434643B706F736974696F6E3A6162736F6C7574653B7A2D696E6465783A31303B70616464696E672D6C6566743A353070783B637572736F723A706F696E7465727D2E626F7820696E7075747B6F7061636974793A303B7669736962696C6974793A6869';
wwv_flow_imp.g_varchar2_table(4) := '6464656E3B706F736974696F6E3A6162736F6C7574657D2E626F7820696E7075743A636865636B65647E2E636865636B7B626F726465722D636F6C6F723A233030656139303B626F782D736861646F773A30203020302031357078202330306561393020';
wwv_flow_imp.g_varchar2_table(5) := '696E7365747D2E626F7820696E7075743A636865636B65647E2E636865636B3A3A61667465727B6F7061636974793A313B7472616E73666F726D3A7363616C652831297D2E626F78202E636865636B7B77696474683A333070783B6865696768743A3330';
wwv_flow_imp.g_varchar2_table(6) := '70783B646973706C61793A666C65783B6A7573746966792D636F6E74656E743A63656E7465723B616C69676E2D6974656D733A63656E7465723B706F736974696F6E3A6162736F6C7574653B626F726465722D7261646975733A31303070783B6261636B';
wwv_flow_imp.g_varchar2_table(7) := '67726F756E642D636F6C6F723A236666663B626F726465723A32707820736F6C696420677261793B626F782D736861646F773A30203020302030202330306561393020696E7365743B7472616E736974696F6E3A616C6C202E3135732063756269632D62';
wwv_flow_imp.g_varchar2_table(8) := '657A69657228302C312E30352C2E37322C312E3037297D2E626F78202E636865636B3A3A61667465727B636F6E74656E743A22223B77696474683A313030253B6865696768743A313030253B6F7061636974793A303B7A2D696E6465783A343B706F7369';
wwv_flow_imp.g_varchar2_table(9) := '74696F6E3A6162736F6C7574653B7472616E73666F726D3A7363616C652830293B6261636B67726F756E642D73697A653A3530253B6261636B67726F756E642D696D6167653A75726C2868747470733A2F2F73362E7069636F66696C652E636F6D2F642F';
wwv_flow_imp.g_varchar2_table(10) := '383339323330363636382F62616363383838632D626564372D343161392D626632342D6636666630373138663437312F636865636B6D61726B2E737667293B6261636B67726F756E642D7265706561743A6E6F2D7265706561743B6261636B67726F756E';
wwv_flow_imp.g_varchar2_table(11) := '642D706F736974696F6E3A63656E7465723B7472616E736974696F6E2D64656C61793A2E327321696D706F7274616E743B7472616E736974696F6E3A616C6C202E3235732063756269632D62657A69657228302C312E30352C2E37322C312E3037297D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26646257416835160)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'soft-toggle-switch.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '746D6C7B626F782D73697A696E673A626F726465722D626F783B666F6E742D66616D696C793A27417269616C272C73616E732D73657269663B666F6E742D73697A653A313030257D2E6D69647B646973706C61793A666C65783B616C69676E2D6974656D';
wwv_flow_imp.g_varchar2_table(2) := '733A63656E7465723B6A7573746966792D636F6E74656E743A63656E7465723B70616464696E672D746F703A307D2E726F636B65727B646973706C61793A696E6C696E652D626C6F636B3B706F736974696F6E3A72656C61746976653B666F6E742D7369';
wwv_flow_imp.g_varchar2_table(3) := '7A653A31656D3B666F6E742D7765696768743A3730303B746578742D616C69676E3A63656E7465723B746578742D7472616E73666F726D3A7570706572636173653B636F6C6F723A233838383B77696474683A37656D3B6865696768743A34656D3B6F76';
wwv_flow_imp.g_varchar2_table(4) := '6572666C6F773A68696464656E3B626F726465722D626F74746F6D3A2E35656D20736F6C696420236565657D2E726F636B65722D736D616C6C7B666F6E742D73697A653A2E3735656D3B6D617267696E3A31656D7D2E726F636B65723A3A6265666F7265';
wwv_flow_imp.g_varchar2_table(5) := '7B636F6E74656E743A22223B706F736974696F6E3A6162736F6C7574653B746F703A2E35656D3B6C6566743A303B72696768743A303B626F74746F6D3A303B6261636B67726F756E642D636F6C6F723A233939393B626F726465723A2E35656D20736F6C';
wwv_flow_imp.g_varchar2_table(6) := '696420236565653B626F726465722D626F74746F6D3A307D2E726F636B657220696E7075747B6F7061636974793A303B77696474683A303B6865696768743A307D2E7377697463682D6C6566742C2E7377697463682D72696768747B637572736F723A70';
wwv_flow_imp.g_varchar2_table(7) := '6F696E7465723B706F736974696F6E3A6162736F6C7574653B646973706C61793A666C65783B616C69676E2D6974656D733A63656E7465723B6A7573746966792D636F6E74656E743A63656E7465723B7472616E736974696F6E3A2E32737D2E73776974';
wwv_flow_imp.g_varchar2_table(8) := '63682D72696768747B6865696768743A322E35656D3B77696474683A33656D7D2E7377697463682D6C6566747B6865696768743A322E34656D3B77696474683A322E3735656D3B6C6566743A2E3835656D3B626F74746F6D3A2E34656D3B6261636B6772';
wwv_flow_imp.g_varchar2_table(9) := '6F756E642D636F6C6F723A236464643B7472616E73666F726D3A726F746174652831356465672920736B657758283135646567297D2E7377697463682D72696768747B72696768743A2E35656D3B626F74746F6D3A303B6261636B67726F756E642D636F';
wwv_flow_imp.g_varchar2_table(10) := '6C6F723A236264353735373B636F6C6F723A236666667D2E7377697463682D6C6566743A3A6265666F72657B6261636B67726F756E642D636F6C6F723A236363633B7472616E73666F726D3A736B657759282D3635646567297D2E7377697463682D6C65';
wwv_flow_imp.g_varchar2_table(11) := '66743A3A6265666F72652C2E7377697463682D72696768743A3A6265666F72657B636F6E74656E743A22223B706F736974696F6E3A6162736F6C7574653B77696474683A2E34656D3B6865696768743A322E3435656D3B626F74746F6D3A2D2E3435656D';
wwv_flow_imp.g_varchar2_table(12) := '7D2E7377697463682D6C6566743A3A6265666F72657B6C6566743A2D2E34656D7D2E7377697463682D72696768743A3A6265666F72657B72696768743A2D2E333735656D3B6261636B67726F756E642D636F6C6F723A7472616E73706172656E743B7472';
wwv_flow_imp.g_varchar2_table(13) := '616E73666F726D3A736B657759283635646567297D696E7075743A636865636B65642B2E7377697463682D6C6566747B636F6C6F723A236666663B626F74746F6D3A303B6C6566743A2E35656D3B6865696768743A322E35656D3B77696474683A33656D';
wwv_flow_imp.g_varchar2_table(14) := '3B7472616E73666F726D3A726F7461746528306465672920736B6577582830646567297D696E7075743A636865636B65642B2E7377697463682D6C6566743A3A6265666F72657B6261636B67726F756E642D636F6C6F723A7472616E73706172656E743B';
wwv_flow_imp.g_varchar2_table(15) := '77696474683A332E30383333656D7D696E7075743A636865636B65642B2E7377697463682D6C6566742B2E7377697463682D72696768747B6261636B67726F756E642D636F6C6F723A236464643B636F6C6F723A233838383B626F74746F6D3A2E34656D';
wwv_flow_imp.g_varchar2_table(16) := '3B72696768743A2E38656D3B6865696768743A322E34656D3B77696474683A322E3735656D3B7472616E73666F726D3A726F74617465282D31356465672920736B657758282D3135646567297D696E7075743A636865636B65642B2E7377697463682D6C';
wwv_flow_imp.g_varchar2_table(17) := '6566742B2E7377697463682D72696768743A3A6265666F72657B6261636B67726F756E642D636F6C6F723A236363637D696E7075743A666F6375732B2E7377697463682D6C6566747B636F6C6F723A233333337D696E7075743A636865636B65643A666F';
wwv_flow_imp.g_varchar2_table(18) := '6375732B2E7377697463682D6C6566747B636F6C6F723A236666667D696E7075743A666F6375732B2E7377697463682D6C6566742B2E7377697463682D72696768747B636F6C6F723A236666667D696E7075743A636865636B65643A666F6375732B2E73';
wwv_flow_imp.g_varchar2_table(19) := '77697463682D6C6566742B2E7377697463682D72696768747B636F6C6F723A233333337D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26650520270040417)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'animatedButton.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E746F67676C65427574746F6E207B0D0A2020637572736F723A20706F696E7465723B0D0A2020646973706C61793A20626C6F636B3B0D0A20207472616E73666F726D2D6F726967696E3A20353025203530253B0D0A20207472616E73666F726D2D7374';
wwv_flow_imp.g_varchar2_table(2) := '796C653A2070726573657276652D33643B0D0A20207472616E736974696F6E3A207472616E73666F726D20302E31347320656173653B0D0A7D0D0A2E746F67676C65427574746F6E3A616374697665207B0D0A20207472616E73666F726D3A20726F7461';
wwv_flow_imp.g_varchar2_table(3) := '746558283330646567293B0D0A7D0D0A2E746F67676C65427574746F6E20696E707574207B0D0A2020646973706C61793A206E6F6E653B0D0A7D0D0A2E746F67676C65427574746F6E20696E707574202B20646976207B0D0A2020626F726465723A2033';
wwv_flow_imp.g_varchar2_table(4) := '707820736F6C69642072676261283235352C203235352C203235352C20302E32293B0D0A2020626F726465722D7261646975733A203530253B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A202077696474683A20343470783B0D0A2020';
wwv_flow_imp.g_varchar2_table(5) := '6865696768743A20343470783B0D0A7D0D0A2E746F67676C65427574746F6E20696E707574202B2064697620737667207B0D0A202066696C6C3A206E6F6E653B0D0A20207374726F6B652D77696474683A20332E363B0D0A20207374726F6B653A204752';
wwv_flow_imp.g_varchar2_table(6) := '45593B0D0A20207374726F6B652D6C696E656361703A20726F756E643B0D0A20207374726F6B652D6C696E656A6F696E3A20726F756E643B0D0A202077696474683A20343470783B0D0A20206865696768743A20343470783B0D0A2020646973706C6179';
wwv_flow_imp.g_varchar2_table(7) := '3A20626C6F636B3B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A20206C6566743A202D3370783B0D0A2020746F703A202D3370783B0D0A202072696768743A202D3370783B0D0A2020626F74746F6D3A202D3370783B0D0A20207A2D69';
wwv_flow_imp.g_varchar2_table(8) := '6E6465783A20313B0D0A20207374726F6B652D646173686F66667365743A203132342E363B0D0A20207374726F6B652D6461736861727261793A2030203136322E36203133332032392E363B0D0A20207472616E736974696F6E3A20616C6C20302E3473';
wwv_flow_imp.g_varchar2_table(9) := '20656173652030733B0D0A7D0D0A2E746F67676C65427574746F6E20696E707574202B206469763A6265666F72652C202E746F67676C65427574746F6E20696E707574202B206469763A6166746572207B0D0A2020636F6E74656E743A2022223B0D0A20';
wwv_flow_imp.g_varchar2_table(10) := '2077696474683A203370783B0D0A20206865696768743A20313670783B0D0A20206261636B67726F756E643A20236666663B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A20206C6566743A203530253B0D0A2020746F703A203530253B';
wwv_flow_imp.g_varchar2_table(11) := '0D0A2020626F726465722D7261646975733A203570783B0D0A7D0D0A2E746F67676C65427574746F6E20696E707574202B206469763A6265666F7265207B0D0A20206F7061636974793A20303B0D0A20207472616E73666F726D3A207363616C6528302E';
wwv_flow_imp.g_varchar2_table(12) := '3329207472616E736C617465282D3530252C202D3530252920726F74617465283435646567293B0D0A20202D7765626B69742D616E696D6174696F6E3A20626F756E6365496E4265666F726520302E3373206C696E65617220666F72776172647320302E';
wwv_flow_imp.g_varchar2_table(13) := '33733B0D0A20202020202020202020616E696D6174696F6E3A20626F756E6365496E4265666F726520302E3373206C696E65617220666F72776172647320302E33733B0D0A7D0D0A2E746F67676C65427574746F6E20696E707574202B206469763A6166';
wwv_flow_imp.g_varchar2_table(14) := '746572207B0D0A20206F7061636974793A20303B0D0A20207472616E73666F726D3A207363616C6528302E3329207472616E736C617465282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20202D7765626B69742D616E696D61';
wwv_flow_imp.g_varchar2_table(15) := '74696F6E3A20626F756E6365496E416674657220302E3373206C696E65617220666F72776172647320302E33733B0D0A20202020202020202020616E696D6174696F6E3A20626F756E6365496E416674657220302E3373206C696E65617220666F727761';
wwv_flow_imp.g_varchar2_table(16) := '72647320302E33733B0D0A7D0D0A2E746F67676C65427574746F6E20696E7075743A636865636B6564202B2064697620737667207B0D0A20207374726F6B652D646173686F66667365743A203136322E363B0D0A20207374726F6B652D64617368617272';
wwv_flow_imp.g_varchar2_table(17) := '61793A2030203136322E36203238203133342E363B0D0A20207472616E736974696F6E3A20616C6C20302E3473206561736520302E32733B0D0A7D0D0A2E746F67676C65427574746F6E20696E7075743A636865636B6564202B206469763A6265666F72';
wwv_flow_imp.g_varchar2_table(18) := '65207B0D0A20206F7061636974793A20303B0D0A20207472616E73666F726D3A207363616C6528302E3329207472616E736C617465282D3530252C202D3530252920726F74617465283435646567293B0D0A20202D7765626B69742D616E696D6174696F';
wwv_flow_imp.g_varchar2_table(19) := '6E3A20626F756E6365496E4265666F7265446F6E7420302E3373206C696E65617220666F7277617264732030733B0D0A20202020202020202020616E696D6174696F6E3A20626F756E6365496E4265666F7265446F6E7420302E3373206C696E65617220';
wwv_flow_imp.g_varchar2_table(20) := '666F7277617264732030733B0D0A7D0D0A2E746F67676C65427574746F6E20696E7075743A636865636B6564202B206469763A6166746572207B0D0A20206F7061636974793A20303B0D0A20207472616E73666F726D3A207363616C6528302E33292074';
wwv_flow_imp.g_varchar2_table(21) := '72616E736C617465282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20202D7765626B69742D616E696D6174696F6E3A20626F756E6365496E4166746572446F6E7420302E3373206C696E65617220666F727761726473203073';
wwv_flow_imp.g_varchar2_table(22) := '3B0D0A20202020202020202020616E696D6174696F6E3A20626F756E6365496E4166746572446F6E7420302E3373206C696E65617220666F7277617264732030733B0D0A7D0D0A0D0A402D7765626B69742D6B65796672616D657320626F756E6365496E';
wwv_flow_imp.g_varchar2_table(23) := '4265666F7265207B0D0A20203025207B0D0A202020206F7061636974793A20303B0D0A202020207472616E73666F726D3A207363616C6528302E3329207472616E736C617465282D3530252C202D3530252920726F74617465283435646567293B0D0A20';
wwv_flow_imp.g_varchar2_table(24) := '207D0D0A2020353025207B0D0A202020206F7061636974793A20302E393B0D0A202020207472616E73666F726D3A207363616C6528312E3129207472616E736C617465282D3530252C202D3530252920726F74617465283435646567293B0D0A20207D0D';
wwv_flow_imp.g_varchar2_table(25) := '0A2020383025207B0D0A202020206F7061636974793A20313B0D0A202020207472616E73666F726D3A207363616C6528302E383929207472616E736C617465282D3530252C202D3530252920726F74617465283435646567293B0D0A20207D0D0A202031';
wwv_flow_imp.g_varchar2_table(26) := '303025207B0D0A202020206F7061636974793A20313B0D0A202020207472616E73666F726D3A207363616C65283129207472616E736C617465282D3530252C202D3530252920726F74617465283435646567293B0D0A20207D0D0A7D0D0A0D0A406B6579';
wwv_flow_imp.g_varchar2_table(27) := '6672616D657320626F756E6365496E4265666F7265207B0D0A20203025207B0D0A202020206F7061636974793A20303B0D0A202020207472616E73666F726D3A207363616C6528302E3329207472616E736C617465282D3530252C202D3530252920726F';
wwv_flow_imp.g_varchar2_table(28) := '74617465283435646567293B0D0A20207D0D0A2020353025207B0D0A202020206F7061636974793A20302E393B0D0A202020207472616E73666F726D3A207363616C6528312E3129207472616E736C617465282D3530252C202D3530252920726F746174';
wwv_flow_imp.g_varchar2_table(29) := '65283435646567293B0D0A20207D0D0A2020383025207B0D0A202020206F7061636974793A20313B0D0A202020207472616E73666F726D3A207363616C6528302E383929207472616E736C617465282D3530252C202D3530252920726F74617465283435';
wwv_flow_imp.g_varchar2_table(30) := '646567293B0D0A20207D0D0A202031303025207B0D0A202020206F7061636974793A20313B0D0A202020207472616E73666F726D3A207363616C65283129207472616E736C617465282D3530252C202D3530252920726F74617465283435646567293B0D';
wwv_flow_imp.g_varchar2_table(31) := '0A20207D0D0A7D0D0A402D7765626B69742D6B65796672616D657320626F756E6365496E4166746572207B0D0A20203025207B0D0A202020206F7061636974793A20303B0D0A202020207472616E73666F726D3A207363616C6528302E3329207472616E';
wwv_flow_imp.g_varchar2_table(32) := '736C617465282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20207D0D0A2020353025207B0D0A202020206F7061636974793A20302E393B0D0A202020207472616E73666F726D3A207363616C6528312E3129207472616E736C';
wwv_flow_imp.g_varchar2_table(33) := '617465282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20207D0D0A2020383025207B0D0A202020206F7061636974793A20313B0D0A202020207472616E73666F726D3A207363616C6528302E383929207472616E736C617465';
wwv_flow_imp.g_varchar2_table(34) := '282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20207D0D0A202031303025207B0D0A202020206F7061636974793A20313B0D0A202020207472616E73666F726D3A207363616C65283129207472616E736C617465282D353025';
wwv_flow_imp.g_varchar2_table(35) := '2C202D3530252920726F74617465282D3435646567293B0D0A20207D0D0A7D0D0A406B65796672616D657320626F756E6365496E4166746572207B0D0A20203025207B0D0A202020206F7061636974793A20303B0D0A202020207472616E73666F726D3A';
wwv_flow_imp.g_varchar2_table(36) := '207363616C6528302E3329207472616E736C617465282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20207D0D0A2020353025207B0D0A202020206F7061636974793A20302E393B0D0A202020207472616E73666F726D3A2073';
wwv_flow_imp.g_varchar2_table(37) := '63616C6528312E3129207472616E736C617465282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20207D0D0A2020383025207B0D0A202020206F7061636974793A20313B0D0A202020207472616E73666F726D3A207363616C65';
wwv_flow_imp.g_varchar2_table(38) := '28302E383929207472616E736C617465282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20207D0D0A202031303025207B0D0A202020206F7061636974793A20313B0D0A202020207472616E73666F726D3A207363616C652831';
wwv_flow_imp.g_varchar2_table(39) := '29207472616E736C617465282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20207D0D0A7D0D0A402D7765626B69742D6B65796672616D657320626F756E6365496E4265666F7265446F6E74207B0D0A20203025207B0D0A2020';
wwv_flow_imp.g_varchar2_table(40) := '20206F7061636974793A20313B0D0A202020207472616E73666F726D3A207363616C65283129207472616E736C617465282D3530252C202D3530252920726F74617465283435646567293B0D0A20207D0D0A202031303025207B0D0A202020206F706163';
wwv_flow_imp.g_varchar2_table(41) := '6974793A20303B0D0A202020207472616E73666F726D3A207363616C6528302E3329207472616E736C617465282D3530252C202D3530252920726F74617465283435646567293B0D0A20207D0D0A7D0D0A406B65796672616D657320626F756E6365496E';
wwv_flow_imp.g_varchar2_table(42) := '4265666F7265446F6E74207B0D0A20203025207B0D0A202020206F7061636974793A20313B0D0A202020207472616E73666F726D3A207363616C65283129207472616E736C617465282D3530252C202D3530252920726F74617465283435646567293B0D';
wwv_flow_imp.g_varchar2_table(43) := '0A20207D0D0A202031303025207B0D0A202020206F7061636974793A20303B0D0A202020207472616E73666F726D3A207363616C6528302E3329207472616E736C617465282D3530252C202D3530252920726F74617465283435646567293B0D0A20207D';
wwv_flow_imp.g_varchar2_table(44) := '0D0A7D0D0A402D7765626B69742D6B65796672616D657320626F756E6365496E4166746572446F6E74207B0D0A20203025207B0D0A202020206F7061636974793A20313B0D0A202020207472616E73666F726D3A207363616C65283129207472616E736C';
wwv_flow_imp.g_varchar2_table(45) := '617465282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20207D0D0A202031303025207B0D0A202020206F7061636974793A20303B0D0A202020207472616E73666F726D3A207363616C6528302E3329207472616E736C617465';
wwv_flow_imp.g_varchar2_table(46) := '282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20207D0D0A7D0D0A406B65796672616D657320626F756E6365496E4166746572446F6E74207B0D0A20203025207B0D0A202020206F7061636974793A20313B0D0A2020202074';
wwv_flow_imp.g_varchar2_table(47) := '72616E73666F726D3A207363616C65283129207472616E736C617465282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20207D0D0A202031303025207B0D0A202020206F7061636974793A20303B0D0A202020207472616E7366';
wwv_flow_imp.g_varchar2_table(48) := '6F726D3A207363616C6528302E3329207472616E736C617465282D3530252C202D3530252920726F74617465282D3435646567293B0D0A20207D0D0A7D0D0A68746D6C207B0D0A2020626F782D73697A696E673A20626F726465722D626F783B0D0A2020';
wwv_flow_imp.g_varchar2_table(49) := '2D7765626B69742D666F6E742D736D6F6F7468696E673A20616E7469616C69617365643B0D0A7D0D0A0D0A2A207B0D0A2020626F782D73697A696E673A20696E68657269743B0D0A7D0D0A2A3A6265666F72652C202A3A6166746572207B0D0A2020626F';
wwv_flow_imp.g_varchar2_table(50) := '782D73697A696E673A20696E68657269743B0D0A7D0D0A0D0A0D0A626F6479202E6472696262626C65207B0D0A2020706F736974696F6E3A2066697865643B0D0A2020646973706C61793A20626C6F636B3B0D0A202072696768743A20323470783B0D0A';
wwv_flow_imp.g_varchar2_table(51) := '2020626F74746F6D3A20323470783B0D0A7D0D0A626F6479202E6472696262626C6520696D67207B0D0A2020646973706C61793A20626C6F636B3B0D0A202077696474683A20373670783B0D0A7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26651398008134797)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'toggleButton.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '402D7765626B69742D6B65796672616D657320626F756E6365496E4265666F72657B30257B6F7061636974793A303B7472616E73666F726D3A7363616C65282E3329207472616E736C617465282D3530252C2D3530252920726F74617465283435646567';
wwv_flow_imp.g_varchar2_table(2) := '297D3530257B6F7061636974793A2E393B7472616E73666F726D3A7363616C6528312E3129207472616E736C617465282D3530252C2D3530252920726F74617465283435646567297D3830257B6F7061636974793A313B7472616E73666F726D3A736361';
wwv_flow_imp.g_varchar2_table(3) := '6C65282E383929207472616E736C617465282D3530252C2D3530252920726F74617465283435646567297D746F7B6F7061636974793A313B7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D3530252920726F7461';
wwv_flow_imp.g_varchar2_table(4) := '7465283435646567297D7D406B65796672616D657320626F756E6365496E4265666F72657B30257B6F7061636974793A303B7472616E73666F726D3A7363616C65282E3329207472616E736C617465282D3530252C2D3530252920726F74617465283435';
wwv_flow_imp.g_varchar2_table(5) := '646567297D3530257B6F7061636974793A2E393B7472616E73666F726D3A7363616C6528312E3129207472616E736C617465282D3530252C2D3530252920726F74617465283435646567297D3830257B6F7061636974793A313B7472616E73666F726D3A';
wwv_flow_imp.g_varchar2_table(6) := '7363616C65282E383929207472616E736C617465282D3530252C2D3530252920726F74617465283435646567297D746F7B6F7061636974793A313B7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D353025292072';
wwv_flow_imp.g_varchar2_table(7) := '6F74617465283435646567297D7D402D7765626B69742D6B65796672616D657320626F756E6365496E41667465727B30257B6F7061636974793A303B7472616E73666F726D3A7363616C65282E3329207472616E736C617465282D3530252C2D35302529';
wwv_flow_imp.g_varchar2_table(8) := '20726F74617465282D3435646567297D3530257B6F7061636974793A2E393B7472616E73666F726D3A7363616C6528312E3129207472616E736C617465282D3530252C2D3530252920726F74617465282D3435646567297D3830257B6F7061636974793A';
wwv_flow_imp.g_varchar2_table(9) := '313B7472616E73666F726D3A7363616C65282E383929207472616E736C617465282D3530252C2D3530252920726F74617465282D3435646567297D746F7B6F7061636974793A313B7472616E73666F726D3A7363616C65283129207472616E736C617465';
wwv_flow_imp.g_varchar2_table(10) := '282D3530252C2D3530252920726F74617465282D3435646567297D7D406B65796672616D657320626F756E6365496E41667465727B30257B6F7061636974793A303B7472616E73666F726D3A7363616C65282E3329207472616E736C617465282D353025';
wwv_flow_imp.g_varchar2_table(11) := '2C2D3530252920726F74617465282D3435646567297D3530257B6F7061636974793A2E393B7472616E73666F726D3A7363616C6528312E3129207472616E736C617465282D3530252C2D3530252920726F74617465282D3435646567297D3830257B6F70';
wwv_flow_imp.g_varchar2_table(12) := '61636974793A313B7472616E73666F726D3A7363616C65282E383929207472616E736C617465282D3530252C2D3530252920726F74617465282D3435646567297D746F7B6F7061636974793A313B7472616E73666F726D3A7363616C6528312920747261';
wwv_flow_imp.g_varchar2_table(13) := '6E736C617465282D3530252C2D3530252920726F74617465282D3435646567297D7D402D7765626B69742D6B65796672616D657320626F756E6365496E4265666F7265446F6E747B30257B6F7061636974793A313B7472616E73666F726D3A7363616C65';
wwv_flow_imp.g_varchar2_table(14) := '283129207472616E736C617465282D3530252C2D3530252920726F74617465283435646567297D746F7B6F7061636974793A303B7472616E73666F726D3A7363616C65282E3329207472616E736C617465282D3530252C2D3530252920726F7461746528';
wwv_flow_imp.g_varchar2_table(15) := '3435646567297D7D406B65796672616D657320626F756E6365496E4265666F7265446F6E747B30257B6F7061636974793A313B7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D3530252920726F74617465283435';
wwv_flow_imp.g_varchar2_table(16) := '646567297D746F7B6F7061636974793A303B7472616E73666F726D3A7363616C65282E3329207472616E736C617465282D3530252C2D3530252920726F74617465283435646567297D7D402D7765626B69742D6B65796672616D657320626F756E636549';
wwv_flow_imp.g_varchar2_table(17) := '6E4166746572446F6E747B30257B6F7061636974793A313B7472616E73666F726D3A7363616C65283129207472616E736C617465282D3530252C2D3530252920726F74617465282D3435646567297D746F7B6F7061636974793A303B7472616E73666F72';
wwv_flow_imp.g_varchar2_table(18) := '6D3A7363616C65282E3329207472616E736C617465282D3530252C2D3530252920726F74617465282D3435646567297D7D406B65796672616D657320626F756E6365496E4166746572446F6E747B30257B6F7061636974793A313B7472616E73666F726D';
wwv_flow_imp.g_varchar2_table(19) := '3A7363616C65283129207472616E736C617465282D3530252C2D3530252920726F74617465282D3435646567297D746F7B6F7061636974793A303B7472616E73666F726D3A7363616C65282E3329207472616E736C617465282D3530252C2D3530252920';
wwv_flow_imp.g_varchar2_table(20) := '726F74617465282D3435646567297D7D2E746F67676C65427574746F6E7B637572736F723A706F696E7465723B646973706C61793A626C6F636B3B7472616E73666F726D2D6F726967696E3A353025203530253B7472616E73666F726D2D7374796C653A';
wwv_flow_imp.g_varchar2_table(21) := '70726573657276652D33643B7472616E736974696F6E3A7472616E73666F726D202E31347320656173657D2E746F67676C65427574746F6E3A6163746976657B7472616E73666F726D3A726F7461746558283330646567297D2E746F67676C6542757474';
wwv_flow_imp.g_varchar2_table(22) := '6F6E20696E7075747B646973706C61793A6E6F6E657D2E746F67676C65427574746F6E20696E7075742B6469767B626F726465723A33707820736F6C69642072676261283235352C3235352C3235352C2E32293B626F726465722D7261646975733A3530';
wwv_flow_imp.g_varchar2_table(23) := '253B706F736974696F6E3A72656C61746976653B77696474683A343470783B6865696768743A343470787D2E746F67676C65427574746F6E20696E7075742B646976207376677B66696C6C3A6E6F6E653B7374726F6B652D77696474683A332E363B7374';
wwv_flow_imp.g_varchar2_table(24) := '726F6B653A677261793B7374726F6B652D6C696E656361703A726F756E643B7374726F6B652D6C696E656A6F696E3A726F756E643B77696474683A343470783B6865696768743A343470783B646973706C61793A626C6F636B3B706F736974696F6E3A61';
wwv_flow_imp.g_varchar2_table(25) := '62736F6C7574653B6C6566743A2D3370783B746F703A2D3370783B72696768743A2D3370783B626F74746F6D3A2D3370783B7A2D696E6465783A313B7374726F6B652D646173686F66667365743A3132342E363B7374726F6B652D646173686172726179';
wwv_flow_imp.g_varchar2_table(26) := '3A30203136322E36203133332032392E363B7472616E736974696F6E3A616C6C202E347320656173652030737D2E746F67676C65427574746F6E20696E7075742B6469763A61667465722C2E746F67676C65427574746F6E20696E7075742B6469763A62';
wwv_flow_imp.g_varchar2_table(27) := '65666F72657B636F6E74656E743A22223B77696474683A3370783B6865696768743A313670783B6261636B67726F756E643A236666663B706F736974696F6E3A6162736F6C7574653B6C6566743A3530253B746F703A3530253B626F726465722D726164';
wwv_flow_imp.g_varchar2_table(28) := '6975733A3570787D2E746F67676C65427574746F6E20696E7075742B6469763A6265666F72657B6F7061636974793A303B7472616E73666F726D3A7363616C65282E3329207472616E736C617465282D3530252C2D3530252920726F7461746528343564';
wwv_flow_imp.g_varchar2_table(29) := '6567293B2D7765626B69742D616E696D6174696F6E3A626F756E6365496E4265666F7265202E3373206C696E65617220666F727761726473202E33733B616E696D6174696F6E3A626F756E6365496E4265666F7265202E3373206C696E65617220666F72';
wwv_flow_imp.g_varchar2_table(30) := '7761726473202E33737D2E746F67676C65427574746F6E20696E7075742B6469763A61667465727B6F7061636974793A303B7472616E73666F726D3A7363616C65282E3329207472616E736C617465282D3530252C2D3530252920726F74617465282D34';
wwv_flow_imp.g_varchar2_table(31) := '35646567293B2D7765626B69742D616E696D6174696F6E3A626F756E6365496E4166746572202E3373206C696E65617220666F727761726473202E33733B616E696D6174696F6E3A626F756E6365496E4166746572202E3373206C696E65617220666F72';
wwv_flow_imp.g_varchar2_table(32) := '7761726473202E33737D2E746F67676C65427574746F6E20696E7075743A636865636B65642B646976207376677B7374726F6B652D646173686F66667365743A3136322E363B7374726F6B652D6461736861727261793A30203136322E36203238203133';
wwv_flow_imp.g_varchar2_table(33) := '342E363B7472616E736974696F6E3A616C6C202E34732065617365202E32737D2E746F67676C65427574746F6E20696E7075743A636865636B65642B6469763A6265666F72657B6F7061636974793A303B7472616E73666F726D3A7363616C65282E3329';
wwv_flow_imp.g_varchar2_table(34) := '207472616E736C617465282D3530252C2D3530252920726F74617465283435646567293B2D7765626B69742D616E696D6174696F6E3A626F756E6365496E4265666F7265446F6E74202E3373206C696E65617220666F7277617264732030733B616E696D';
wwv_flow_imp.g_varchar2_table(35) := '6174696F6E3A626F756E6365496E4265666F7265446F6E74202E3373206C696E65617220666F7277617264732030737D2E746F67676C65427574746F6E20696E7075743A636865636B65642B6469763A61667465727B6F7061636974793A303B7472616E';
wwv_flow_imp.g_varchar2_table(36) := '73666F726D3A7363616C65282E3329207472616E736C617465282D3530252C2D3530252920726F74617465282D3435646567293B2D7765626B69742D616E696D6174696F6E3A626F756E6365496E4166746572446F6E74202E3373206C696E6561722066';
wwv_flow_imp.g_varchar2_table(37) := '6F7277617264732030733B616E696D6174696F6E3A626F756E6365496E4166746572446F6E74202E3373206C696E65617220666F7277617264732030737D68746D6C7B626F782D73697A696E673A626F726465722D626F783B2D7765626B69742D666F6E';
wwv_flow_imp.g_varchar2_table(38) := '742D736D6F6F7468696E673A616E7469616C69617365647D2A2C3A61667465722C3A6265666F72657B626F782D73697A696E673A696E68657269747D626F6479202E6472696262626C657B706F736974696F6E3A66697865643B646973706C61793A626C';
wwv_flow_imp.g_varchar2_table(39) := '6F636B3B72696768743A323470783B626F74746F6D3A323470787D626F6479202E6472696262626C6520696D677B646973706C61793A626C6F636B3B77696474683A373670787D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26660668033264525)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'toggleButton.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A2A0D0A202A207072657474792D636865636B626F782E6373730D0A202A0D0A202A2041207075726520435353206C69627261727920746F20626561757469667920636865636B626F7820616E6420726164696F20627574746F6E730D0A202A0D0A20';
wwv_flow_imp.g_varchar2_table(2) := '2A20536F757263653A2068747470733A2F2F6769746875622E636F6D2F6C6F6B6573682D636F6465722F7072657474792D636865636B626F780D0A202A2044656D6F3A2068747470733A2F2F6C6F6B6573682D636F6465722E6769746875622E696F2F70';
wwv_flow_imp.g_varchar2_table(3) := '72657474792D636865636B626F780D0A202A0D0A202A20436F70797269676874202863292032303137204C6F6B6573682072616A656E6472616E0D0A202A2F0D0A0D0A2E707265747479202A7B626F782D73697A696E673A626F726465722D626F787D2E';
wwv_flow_imp.g_varchar2_table(4) := '70726574747920696E7075743A6E6F74285B747970653D636865636B626F785D293A6E6F74285B747970653D726164696F5D297B646973706C61793A6E6F6E657D2E7072657474797B706F736974696F6E3A72656C61746976653B646973706C61793A69';
wwv_flow_imp.g_varchar2_table(5) := '6E6C696E652D626C6F636B3B6D617267696E2D72696768743A31656D3B77686974652D73706163653A6E6F777261703B6C696E652D6865696768743A317D2E70726574747920696E7075747B706F736974696F6E3A6162736F6C7574653B6C6566743A30';
wwv_flow_imp.g_varchar2_table(6) := '3B746F703A303B6D696E2D77696474683A31656D3B77696474683A313030253B6865696768743A313030253B7A2D696E6465783A323B6F7061636974793A303B6D617267696E3A303B70616464696E673A303B637572736F723A706F696E7465727D2E70';
wwv_flow_imp.g_varchar2_table(7) := '7265747479202E7374617465206C6162656C7B706F736974696F6E3A696E697469616C3B646973706C61793A696E6C696E652D626C6F636B3B666F6E742D7765696768743A3430303B6D617267696E3A303B746578742D696E64656E743A312E35656D3B';
wwv_flow_imp.g_varchar2_table(8) := '6D696E2D77696474683A63616C632831656D202B20327078297D2E707265747479202E7374617465206C6162656C3A61667465722C2E707265747479202E7374617465206C6162656C3A6265666F72657B636F6E74656E743A27273B77696474683A6361';
wwv_flow_imp.g_varchar2_table(9) := '6C632831656D202B20327078293B6865696768743A63616C632831656D202B20327078293B646973706C61793A626C6F636B3B626F782D73697A696E673A626F726465722D626F783B626F726465722D7261646975733A303B626F726465723A31707820';
wwv_flow_imp.g_varchar2_table(10) := '736F6C6964207472616E73706172656E743B7A2D696E6465783A303B706F736974696F6E3A6162736F6C7574653B6C6566743A303B746F703A63616C6328283025202D202831303025202D2031656D2929202D203825293B6261636B67726F756E642D63';
wwv_flow_imp.g_varchar2_table(11) := '6F6C6F723A7472616E73706172656E747D2E707265747479202E7374617465206C6162656C3A6265666F72657B626F726465722D636F6C6F723A236264633363377D2E707265747479202E73746174652E702D69732D686F7665722C2E70726574747920';
wwv_flow_imp.g_varchar2_table(12) := '2E73746174652E702D69732D696E64657465726D696E6174657B646973706C61793A6E6F6E657D402D7765626B69742D6B65796672616D6573207A6F6F6D7B30257B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7363616C6528';
wwv_flow_imp.g_varchar2_table(13) := '30293B7472616E73666F726D3A7363616C652830297D7D406B65796672616D6573207A6F6F6D7B30257B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7363616C652830293B7472616E73666F726D3A7363616C652830297D7D40';
wwv_flow_imp.g_varchar2_table(14) := '2D7765626B69742D6B65796672616D657320746164617B30257B2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D69';
wwv_flow_imp.g_varchar2_table(15) := '6E3B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7363616C652837293B7472616E73666F726D3A7363616C652837297D3338257B2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A65617365';
wwv_flow_imp.g_varchar2_table(16) := '2D6F75743B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75743B6F7061636974793A313B2D7765626B69742D7472616E73666F726D3A7363616C652831293B7472616E73666F726D3A7363616C652831297D3535257B';
wwv_flow_imp.g_varchar2_table(17) := '2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B2D7765626B69742D7472616E73666F726D3A7363616C6528';
wwv_flow_imp.g_varchar2_table(18) := '312E35293B7472616E73666F726D3A7363616C6528312E35297D3732257B2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75743B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A65';
wwv_flow_imp.g_varchar2_table(19) := '6173652D6F75743B2D7765626B69742D7472616E73666F726D3A7363616C652831293B7472616E73666F726D3A7363616C652831297D3831257B2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B';
wwv_flow_imp.g_varchar2_table(20) := '616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B2D7765626B69742D7472616E73666F726D3A7363616C6528312E3234293B7472616E73666F726D3A7363616C6528312E3234297D3839257B2D7765626B69742D616E';
wwv_flow_imp.g_varchar2_table(21) := '696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75743B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75743B2D7765626B69742D7472616E73666F726D3A7363616C652831293B7472616E73';
wwv_flow_imp.g_varchar2_table(22) := '666F726D3A7363616C652831297D3935257B2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B2D7765626B69';
wwv_flow_imp.g_varchar2_table(23) := '742D7472616E73666F726D3A7363616C6528312E3034293B7472616E73666F726D3A7363616C6528312E3034297D313030257B2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75743B616E696D6174';
wwv_flow_imp.g_varchar2_table(24) := '696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75743B2D7765626B69742D7472616E73666F726D3A7363616C652831293B7472616E73666F726D3A7363616C652831297D7D406B65796672616D657320746164617B30257B2D7765626B';
wwv_flow_imp.g_varchar2_table(25) := '69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A73';
wwv_flow_imp.g_varchar2_table(26) := '63616C652837293B7472616E73666F726D3A7363616C652837297D3338257B2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75743B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A';
wwv_flow_imp.g_varchar2_table(27) := '656173652D6F75743B6F7061636974793A313B2D7765626B69742D7472616E73666F726D3A7363616C652831293B7472616E73666F726D3A7363616C652831297D3535257B2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E637469';
wwv_flow_imp.g_varchar2_table(28) := '6F6E3A656173652D696E3B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B2D7765626B69742D7472616E73666F726D3A7363616C6528312E35293B7472616E73666F726D3A7363616C6528312E35297D3732257B2D';
wwv_flow_imp.g_varchar2_table(29) := '7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75743B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75743B2D7765626B69742D7472616E73666F726D3A7363616C65';
wwv_flow_imp.g_varchar2_table(30) := '2831293B7472616E73666F726D3A7363616C652831297D3831257B2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D';
wwv_flow_imp.g_varchar2_table(31) := '696E3B2D7765626B69742D7472616E73666F726D3A7363616C6528312E3234293B7472616E73666F726D3A7363616C6528312E3234297D3839257B2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75';
wwv_flow_imp.g_varchar2_table(32) := '743B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75743B2D7765626B69742D7472616E73666F726D3A7363616C652831293B7472616E73666F726D3A7363616C652831297D3935257B2D7765626B69742D616E696D61';
wwv_flow_imp.g_varchar2_table(33) := '74696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D696E3B2D7765626B69742D7472616E73666F726D3A7363616C6528312E3034293B7472616E73666F';
wwv_flow_imp.g_varchar2_table(34) := '726D3A7363616C6528312E3034297D313030257B2D7765626B69742D616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75743B616E696D6174696F6E2D74696D696E672D66756E6374696F6E3A656173652D6F75743B2D77';
wwv_flow_imp.g_varchar2_table(35) := '65626B69742D7472616E73666F726D3A7363616C652831293B7472616E73666F726D3A7363616C652831297D7D402D7765626B69742D6B65796672616D6573206A656C6C797B30257B2D7765626B69742D7472616E73666F726D3A7363616C6533642831';
wwv_flow_imp.g_varchar2_table(36) := '2C312C31293B7472616E73666F726D3A7363616C65336428312C312C31297D3330257B2D7765626B69742D7472616E73666F726D3A7363616C653364282E37352C312E32352C31293B7472616E73666F726D3A7363616C653364282E37352C312E32352C';
wwv_flow_imp.g_varchar2_table(37) := '31297D3430257B2D7765626B69742D7472616E73666F726D3A7363616C65336428312E32352C2E37352C31293B7472616E73666F726D3A7363616C65336428312E32352C2E37352C31297D3530257B2D7765626B69742D7472616E73666F726D3A736361';
wwv_flow_imp.g_varchar2_table(38) := '6C653364282E38352C312E31352C31293B7472616E73666F726D3A7363616C653364282E38352C312E31352C31297D3635257B2D7765626B69742D7472616E73666F726D3A7363616C65336428312E30352C2E39352C31293B7472616E73666F726D3A73';
wwv_flow_imp.g_varchar2_table(39) := '63616C65336428312E30352C2E39352C31297D3735257B2D7765626B69742D7472616E73666F726D3A7363616C653364282E39352C312E30352C31293B7472616E73666F726D3A7363616C653364282E39352C312E30352C31297D313030257B2D776562';
wwv_flow_imp.g_varchar2_table(40) := '6B69742D7472616E73666F726D3A7363616C65336428312C312C31293B7472616E73666F726D3A7363616C65336428312C312C31297D7D406B65796672616D6573206A656C6C797B30257B2D7765626B69742D7472616E73666F726D3A7363616C653364';
wwv_flow_imp.g_varchar2_table(41) := '28312C312C31293B7472616E73666F726D3A7363616C65336428312C312C31297D3330257B2D7765626B69742D7472616E73666F726D3A7363616C653364282E37352C312E32352C31293B7472616E73666F726D3A7363616C653364282E37352C312E32';
wwv_flow_imp.g_varchar2_table(42) := '352C31297D3430257B2D7765626B69742D7472616E73666F726D3A7363616C65336428312E32352C2E37352C31293B7472616E73666F726D3A7363616C65336428312E32352C2E37352C31297D3530257B2D7765626B69742D7472616E73666F726D3A73';
wwv_flow_imp.g_varchar2_table(43) := '63616C653364282E38352C312E31352C31293B7472616E73666F726D3A7363616C653364282E38352C312E31352C31297D3635257B2D7765626B69742D7472616E73666F726D3A7363616C65336428312E30352C2E39352C31293B7472616E73666F726D';
wwv_flow_imp.g_varchar2_table(44) := '3A7363616C65336428312E30352C2E39352C31297D3735257B2D7765626B69742D7472616E73666F726D3A7363616C653364282E39352C312E30352C31293B7472616E73666F726D3A7363616C653364282E39352C312E30352C31297D313030257B2D77';
wwv_flow_imp.g_varchar2_table(45) := '65626B69742D7472616E73666F726D3A7363616C65336428312C312C31293B7472616E73666F726D3A7363616C65336428312C312C31297D7D402D7765626B69742D6B65796672616D657320726F746174657B30257B6F7061636974793A303B2D776562';
wwv_flow_imp.g_varchar2_table(46) := '6B69742D7472616E73666F726D3A7472616E736C6174655A282D32303070782920726F74617465282D3435646567293B7472616E73666F726D3A7472616E736C6174655A282D32303070782920726F74617465282D3435646567297D313030257B6F7061';
wwv_flow_imp.g_varchar2_table(47) := '636974793A313B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655A28302920726F746174652830293B7472616E73666F726D3A7472616E736C6174655A28302920726F746174652830297D7D406B65796672616D657320726F746174';
wwv_flow_imp.g_varchar2_table(48) := '657B30257B6F7061636974793A303B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655A282D32303070782920726F74617465282D3435646567293B7472616E73666F726D3A7472616E736C6174655A282D32303070782920726F7461';
wwv_flow_imp.g_varchar2_table(49) := '7465282D3435646567297D313030257B6F7061636974793A313B2D7765626B69742D7472616E73666F726D3A7472616E736C6174655A28302920726F746174652830293B7472616E73666F726D3A7472616E736C6174655A28302920726F746174652830';
wwv_flow_imp.g_varchar2_table(50) := '297D7D402D7765626B69742D6B65796672616D65732070756C73657B30257B626F782D736861646F773A3020302030203020236264633363377D313030257B626F782D736861646F773A302030203020312E35656D2072676261283138392C3139352C31';
wwv_flow_imp.g_varchar2_table(51) := '39392C30297D7D406B65796672616D65732070756C73657B30257B626F782D736861646F773A3020302030203020236264633363377D313030257B626F782D736861646F773A302030203020312E35656D2072676261283138392C3139352C3139392C30';
wwv_flow_imp.g_varchar2_table(52) := '297D7D2E7072657474792E702D64656661756C742E702D66696C6C202E7374617465206C6162656C3A61667465727B2D7765626B69742D7472616E73666F726D3A7363616C652831293B2D6D732D7472616E73666F726D3A7363616C652831293B747261';
wwv_flow_imp.g_varchar2_table(53) := '6E73666F726D3A7363616C652831297D2E7072657474792E702D64656661756C74202E7374617465206C6162656C3A61667465727B2D7765626B69742D7472616E73666F726D3A7363616C65282E36293B2D6D732D7472616E73666F726D3A7363616C65';
wwv_flow_imp.g_varchar2_table(54) := '282E36293B7472616E73666F726D3A7363616C65282E36297D2E7072657474792E702D64656661756C7420696E7075743A636865636B65647E2E7374617465206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A23626463336337';
wwv_flow_imp.g_varchar2_table(55) := '21696D706F7274616E747D2E7072657474792E702D64656661756C742E702D746869636B202E7374617465206C6162656C3A61667465722C2E7072657474792E702D64656661756C742E702D746869636B202E7374617465206C6162656C3A6265666F72';
wwv_flow_imp.g_varchar2_table(56) := '657B626F726465722D77696474683A63616C632831656D202F2037297D2E7072657474792E702D64656661756C742E702D746869636B202E7374617465206C6162656C3A61667465727B2D7765626B69742D7472616E73666F726D3A7363616C65282E34';
wwv_flow_imp.g_varchar2_table(57) := '2921696D706F7274616E743B2D6D732D7472616E73666F726D3A7363616C65282E342921696D706F7274616E743B7472616E73666F726D3A7363616C65282E342921696D706F7274616E747D2E7072657474792E702D69636F6E202E7374617465202E69';
wwv_flow_imp.g_varchar2_table(58) := '636F6E7B706F736974696F6E3A6162736F6C7574653B666F6E742D73697A653A31656D3B77696474683A63616C632831656D202B20327078293B6865696768743A63616C632831656D202B20327078293B6C6566743A303B7A2D696E6465783A313B7465';
wwv_flow_imp.g_varchar2_table(59) := '78742D616C69676E3A63656E7465723B6C696E652D6865696768743A6E6F726D616C3B746F703A63616C6328283025202D202831303025202D2031656D2929202D203825293B626F726465723A31707820736F6C6964207472616E73706172656E743B6F';
wwv_flow_imp.g_varchar2_table(60) := '7061636974793A307D2E7072657474792E702D69636F6E202E7374617465202E69636F6E3A6265666F72657B6D617267696E3A303B77696474683A313030253B6865696768743A313030253B746578742D616C69676E3A63656E7465723B646973706C61';
wwv_flow_imp.g_varchar2_table(61) := '793A2D7765626B69742D626F783B646973706C61793A2D6D732D666C6578626F783B646973706C61793A666C65783B2D7765626B69742D626F782D666C65783A313B2D6D732D666C65783A313B666C65783A313B2D7765626B69742D626F782D7061636B';
wwv_flow_imp.g_varchar2_table(62) := '3A63656E7465723B2D6D732D666C65782D7061636B3A63656E7465723B6A7573746966792D636F6E74656E743A63656E7465723B2D7765626B69742D626F782D616C69676E3A63656E7465723B2D6D732D666C65782D616C69676E3A63656E7465723B61';
wwv_flow_imp.g_varchar2_table(63) := '6C69676E2D6974656D733A63656E7465723B6C696E652D6865696768743A317D2E7072657474792E702D69636F6E20696E7075743A636865636B65647E2E7374617465202E69636F6E7B6F7061636974793A317D2E7072657474792E702D69636F6E2069';
wwv_flow_imp.g_varchar2_table(64) := '6E7075743A636865636B65647E2E7374617465206C6162656C3A6265666F72657B626F726465722D636F6C6F723A233561363536627D2E7072657474792E702D737667202E7374617465202E7376677B706F736974696F6E3A6162736F6C7574653B666F';
wwv_flow_imp.g_varchar2_table(65) := '6E742D73697A653A31656D3B77696474683A63616C632831656D202B20327078293B6865696768743A63616C632831656D202B20327078293B6C6566743A303B7A2D696E6465783A313B746578742D616C69676E3A63656E7465723B6C696E652D686569';
wwv_flow_imp.g_varchar2_table(66) := '6768743A6E6F726D616C3B746F703A63616C6328283025202D202831303025202D2031656D2929202D203825293B626F726465723A31707820736F6C6964207472616E73706172656E743B6F7061636974793A307D2E7072657474792E702D737667202E';
wwv_flow_imp.g_varchar2_table(67) := '7374617465207376677B6D617267696E3A303B77696474683A313030253B6865696768743A313030253B746578742D616C69676E3A63656E7465723B646973706C61793A2D7765626B69742D626F783B646973706C61793A2D6D732D666C6578626F783B';
wwv_flow_imp.g_varchar2_table(68) := '646973706C61793A666C65783B2D7765626B69742D626F782D666C65783A313B2D6D732D666C65783A313B666C65783A313B2D7765626B69742D626F782D7061636B3A63656E7465723B2D6D732D666C65782D7061636B3A63656E7465723B6A75737469';
wwv_flow_imp.g_varchar2_table(69) := '66792D636F6E74656E743A63656E7465723B2D7765626B69742D626F782D616C69676E3A63656E7465723B2D6D732D666C65782D616C69676E3A63656E7465723B616C69676E2D6974656D733A63656E7465723B6C696E652D6865696768743A317D2E70';
wwv_flow_imp.g_varchar2_table(70) := '72657474792E702D73766720696E7075743A636865636B65647E2E7374617465202E7376677B6F7061636974793A317D2E7072657474792E702D696D616765202E737461746520696D677B6F7061636974793A303B706F736974696F6E3A6162736F6C75';
wwv_flow_imp.g_varchar2_table(71) := '74653B77696474683A63616C632831656D202B20327078293B6865696768743A63616C632831656D202B20327078293B746F703A303B746F703A63616C6328283025202D202831303025202D2031656D2929202D203825293B6C6566743A303B7A2D696E';
wwv_flow_imp.g_varchar2_table(72) := '6465783A303B746578742D616C69676E3A63656E7465723B6C696E652D6865696768743A6E6F726D616C3B2D7765626B69742D7472616E73666F726D3A7363616C65282E38293B2D6D732D7472616E73666F726D3A7363616C65282E38293B7472616E73';
wwv_flow_imp.g_varchar2_table(73) := '666F726D3A7363616C65282E38297D2E7072657474792E702D696D61676520696E7075743A636865636B65647E2E737461746520696D677B6F7061636974793A317D2E7072657474792E702D73776974636820696E7075747B6D696E2D77696474683A32';
wwv_flow_imp.g_varchar2_table(74) := '656D7D2E7072657474792E702D737769746368202E73746174657B706F736974696F6E3A72656C61746976657D2E7072657474792E702D737769746368202E73746174653A6265666F72657B636F6E74656E743A27273B626F726465723A31707820736F';
wwv_flow_imp.g_varchar2_table(75) := '6C696420236264633363373B626F726465722D7261646975733A363070783B77696474683A32656D3B626F782D73697A696E673A756E7365743B6865696768743A63616C632831656D202B20327078293B706F736974696F6E3A6162736F6C7574653B74';
wwv_flow_imp.g_varchar2_table(76) := '6F703A303B746F703A63616C6328283025202D202831303025202D2031656D2929202D20313625293B7A2D696E6465783A303B7472616E736974696F6E3A616C6C202E357320656173657D2E7072657474792E702D737769746368202E7374617465206C';
wwv_flow_imp.g_varchar2_table(77) := '6162656C7B746578742D696E64656E743A322E35656D7D2E7072657474792E702D737769746368202E7374617465206C6162656C3A61667465722C2E7072657474792E702D737769746368202E7374617465206C6162656C3A6265666F72657B7472616E';
wwv_flow_imp.g_varchar2_table(78) := '736974696F6E3A616C6C202E357320656173653B626F726465722D7261646975733A313030253B6C6566743A303B626F726465722D636F6C6F723A7472616E73706172656E743B2D7765626B69742D7472616E73666F726D3A7363616C65282E38293B2D';
wwv_flow_imp.g_varchar2_table(79) := '6D732D7472616E73666F726D3A7363616C65282E38293B7472616E73666F726D3A7363616C65282E38297D2E7072657474792E702D737769746368202E7374617465206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A23626463';
wwv_flow_imp.g_varchar2_table(80) := '33633721696D706F7274616E747D2E7072657474792E702D73776974636820696E7075743A636865636B65647E2E73746174653A6265666F72657B626F726465722D636F6C6F723A233561363536627D2E7072657474792E702D73776974636820696E70';
wwv_flow_imp.g_varchar2_table(81) := '75743A636865636B65647E2E7374617465206C6162656C3A6265666F72657B6F7061636974793A307D2E7072657474792E702D73776974636820696E7075743A636865636B65647E2E7374617465206C6162656C3A61667465727B6261636B67726F756E';
wwv_flow_imp.g_varchar2_table(82) := '642D636F6C6F723A2335613635366221696D706F7274616E743B6C6566743A31656D7D2E7072657474792E702D7377697463682E702D66696C6C20696E7075743A636865636B65647E2E73746174653A6265666F72657B626F726465722D636F6C6F723A';
wwv_flow_imp.g_varchar2_table(83) := '233561363536623B6261636B67726F756E642D636F6C6F723A2335613635366221696D706F7274616E747D2E7072657474792E702D7377697463682E702D66696C6C20696E7075743A636865636B65647E2E7374617465206C6162656C3A6265666F7265';
wwv_flow_imp.g_varchar2_table(84) := '7B6F7061636974793A307D2E7072657474792E702D7377697463682E702D66696C6C20696E7075743A636865636B65647E2E7374617465206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A2366666621696D706F7274616E743B';
wwv_flow_imp.g_varchar2_table(85) := '6C6566743A31656D7D2E7072657474792E702D7377697463682E702D736C696D202E73746174653A6265666F72657B6865696768743A2E31656D3B6261636B67726F756E643A2362646333633721696D706F7274616E743B746F703A63616C6328353025';
wwv_flow_imp.g_varchar2_table(86) := '202D202E31656D297D2E7072657474792E702D7377697463682E702D736C696D20696E7075743A636865636B65647E2E73746174653A6265666F72657B626F726465722D636F6C6F723A233561363536623B6261636B67726F756E642D636F6C6F723A23';
wwv_flow_imp.g_varchar2_table(87) := '35613635366221696D706F7274616E747D2E7072657474792E702D6861732D686F76657220696E7075743A686F7665727E2E73746174653A6E6F74282E702D69732D686F766572297B646973706C61793A6E6F6E657D2E7072657474792E702D6861732D';
wwv_flow_imp.g_varchar2_table(88) := '686F76657220696E7075743A686F7665727E2E73746174652E702D69732D686F7665727B646973706C61793A626C6F636B7D2E7072657474792E702D6861732D686F76657220696E7075743A686F7665727E2E73746174652E702D69732D686F76657220';
wwv_flow_imp.g_varchar2_table(89) := '2E69636F6E7B646973706C61793A626C6F636B7D2E7072657474792E702D6861732D666F63757320696E7075743A666F6375737E2E7374617465206C6162656C3A6265666F72657B626F782D736861646F773A3020302033707820302023626463336337';
wwv_flow_imp.g_varchar2_table(90) := '7D2E7072657474792E702D6861732D696E64657465726D696E61746520696E7075745B747970653D636865636B626F785D3A696E64657465726D696E6174657E2E73746174653A6E6F74282E702D69732D696E64657465726D696E617465297B64697370';
wwv_flow_imp.g_varchar2_table(91) := '6C61793A6E6F6E657D2E7072657474792E702D6861732D696E64657465726D696E61746520696E7075745B747970653D636865636B626F785D3A696E64657465726D696E6174657E2E73746174652E702D69732D696E64657465726D696E6174657B6469';
wwv_flow_imp.g_varchar2_table(92) := '73706C61793A626C6F636B7D2E7072657474792E702D6861732D696E64657465726D696E61746520696E7075745B747970653D636865636B626F785D3A696E64657465726D696E6174657E2E73746174652E702D69732D696E64657465726D696E617465';
wwv_flow_imp.g_varchar2_table(93) := '202E69636F6E7B646973706C61793A626C6F636B3B6F7061636974793A317D2E7072657474792E702D746F67676C65202E73746174652E702D6F6E7B6F7061636974793A303B646973706C61793A6E6F6E657D2E7072657474792E702D746F67676C6520';
wwv_flow_imp.g_varchar2_table(94) := '2E7374617465202E69636F6E2C2E7072657474792E702D746F67676C65202E7374617465202E7376672C2E7072657474792E702D746F67676C65202E737461746520696D672C2E7072657474792E702D746F67676C65202E73746174652E702D6F66667B';
wwv_flow_imp.g_varchar2_table(95) := '6F7061636974793A313B646973706C61793A696E68657269747D2E7072657474792E702D746F67676C65202E73746174652E702D6F6666202E69636F6E7B636F6C6F723A236264633363377D2E7072657474792E702D746F67676C6520696E7075743A63';
wwv_flow_imp.g_varchar2_table(96) := '6865636B65647E2E73746174652E702D6F6E7B6F7061636974793A313B646973706C61793A696E68657269747D2E7072657474792E702D746F67676C6520696E7075743A636865636B65647E2E73746174652E702D6F66667B6F7061636974793A303B64';
wwv_flow_imp.g_varchar2_table(97) := '6973706C61793A6E6F6E657D2E7072657474792E702D706C61696E20696E7075743A636865636B65647E2E7374617465206C6162656C3A6265666F72652C2E7072657474792E702D706C61696E2E702D746F67676C65202E7374617465206C6162656C3A';
wwv_flow_imp.g_varchar2_table(98) := '6265666F72657B636F6E74656E743A6E6F6E657D2E7072657474792E702D706C61696E2E702D706C61696E202E69636F6E7B2D7765626B69742D7472616E73666F726D3A7363616C6528312E31293B2D6D732D7472616E73666F726D3A7363616C652831';
wwv_flow_imp.g_varchar2_table(99) := '2E31293B7472616E73666F726D3A7363616C6528312E31297D2E7072657474792E702D726F756E64202E7374617465206C6162656C3A61667465722C2E7072657474792E702D726F756E64202E7374617465206C6162656C3A6265666F72657B626F7264';
wwv_flow_imp.g_varchar2_table(100) := '65722D7261646975733A313030257D2E7072657474792E702D726F756E642E702D69636F6E202E7374617465202E69636F6E7B626F726465722D7261646975733A313030253B6F766572666C6F773A68696464656E7D2E7072657474792E702D726F756E';
wwv_flow_imp.g_varchar2_table(101) := '642E702D69636F6E202E7374617465202E69636F6E3A6265666F72657B2D7765626B69742D7472616E73666F726D3A7363616C65282E38293B2D6D732D7472616E73666F726D3A7363616C65282E38293B7472616E73666F726D3A7363616C65282E3829';
wwv_flow_imp.g_varchar2_table(102) := '7D2E7072657474792E702D6375727665202E7374617465206C6162656C3A61667465722C2E7072657474792E702D6375727665202E7374617465206C6162656C3A6265666F72657B626F726465722D7261646975733A3230257D2E7072657474792E702D';
wwv_flow_imp.g_varchar2_table(103) := '736D6F6F7468202E69636F6E2C2E7072657474792E702D736D6F6F7468202E7376672C2E7072657474792E702D736D6F6F7468206C6162656C3A61667465722C2E7072657474792E702D736D6F6F7468206C6162656C3A6265666F72657B7472616E7369';
wwv_flow_imp.g_varchar2_table(104) := '74696F6E3A616C6C202E357320656173657D2E7072657474792E702D736D6F6F746820696E7075743A636865636B65642B2E7374617465206C6162656C3A61667465727B7472616E736974696F6E3A616C6C202E337320656173657D2E7072657474792E';
wwv_flow_imp.g_varchar2_table(105) := '702D736D6F6F746820696E7075743A636865636B65642B2E7374617465202E69636F6E2C2E7072657474792E702D736D6F6F746820696E7075743A636865636B65642B2E7374617465202E7376672C2E7072657474792E702D736D6F6F746820696E7075';
wwv_flow_imp.g_varchar2_table(106) := '743A636865636B65642B2E737461746520696D677B2D7765626B69742D616E696D6174696F6E3A7A6F6F6D202E327320656173653B616E696D6174696F6E3A7A6F6F6D202E327320656173657D2E7072657474792E702D736D6F6F74682E702D64656661';
wwv_flow_imp.g_varchar2_table(107) := '756C7420696E7075743A636865636B65642B2E7374617465206C6162656C3A61667465727B2D7765626B69742D616E696D6174696F6E3A7A6F6F6D202E327320656173653B616E696D6174696F6E3A7A6F6F6D202E327320656173657D2E707265747479';
wwv_flow_imp.g_varchar2_table(108) := '2E702D736D6F6F74682E702D706C61696E20696E7075743A636865636B65642B2E7374617465206C6162656C3A6265666F72657B636F6E74656E743A27273B2D7765626B69742D7472616E73666F726D3A7363616C652830293B2D6D732D7472616E7366';
wwv_flow_imp.g_varchar2_table(109) := '6F726D3A7363616C652830293B7472616E73666F726D3A7363616C652830293B7472616E736974696F6E3A616C6C202E357320656173657D2E7072657474792E702D746164613A6E6F74282E702D64656661756C742920696E7075743A636865636B6564';
wwv_flow_imp.g_varchar2_table(110) := '2B2E7374617465202E69636F6E2C2E7072657474792E702D746164613A6E6F74282E702D64656661756C742920696E7075743A636865636B65642B2E7374617465202E7376672C2E7072657474792E702D746164613A6E6F74282E702D64656661756C74';
wwv_flow_imp.g_varchar2_table(111) := '2920696E7075743A636865636B65642B2E737461746520696D672C2E7072657474792E702D746164613A6E6F74282E702D64656661756C742920696E7075743A636865636B65642B2E7374617465206C6162656C3A61667465722C2E7072657474792E70';
wwv_flow_imp.g_varchar2_table(112) := '2D746164613A6E6F74282E702D64656661756C742920696E7075743A636865636B65642B2E7374617465206C6162656C3A6265666F72657B2D7765626B69742D616E696D6174696F6E3A74616461202E37732063756269632D62657A696572282E32352C';
wwv_flow_imp.g_varchar2_table(113) := '2E34362C2E34352C2E393429203120616C7465726E6174653B616E696D6174696F6E3A74616461202E37732063756269632D62657A696572282E32352C2E34362C2E34352C2E393429203120616C7465726E6174653B6F7061636974793A317D2E707265';
wwv_flow_imp.g_varchar2_table(114) := '7474792E702D6A656C6C793A6E6F74282E702D64656661756C742920696E7075743A636865636B65642B2E7374617465202E69636F6E2C2E7072657474792E702D6A656C6C793A6E6F74282E702D64656661756C742920696E7075743A636865636B6564';
wwv_flow_imp.g_varchar2_table(115) := '2B2E7374617465202E7376672C2E7072657474792E702D6A656C6C793A6E6F74282E702D64656661756C742920696E7075743A636865636B65642B2E737461746520696D672C2E7072657474792E702D6A656C6C793A6E6F74282E702D64656661756C74';
wwv_flow_imp.g_varchar2_table(116) := '2920696E7075743A636865636B65642B2E7374617465206C6162656C3A61667465722C2E7072657474792E702D6A656C6C793A6E6F74282E702D64656661756C742920696E7075743A636865636B65642B2E7374617465206C6162656C3A6265666F7265';
wwv_flow_imp.g_varchar2_table(117) := '7B2D7765626B69742D616E696D6174696F6E3A6A656C6C79202E37732063756269632D62657A696572282E32352C2E34362C2E34352C2E3934293B616E696D6174696F6E3A6A656C6C79202E37732063756269632D62657A696572282E32352C2E34362C';
wwv_flow_imp.g_varchar2_table(118) := '2E34352C2E3934293B6F7061636974793A317D2E7072657474792E702D6A656C6C793A6E6F74282E702D64656661756C742920696E7075743A636865636B65642B2E7374617465206C6162656C3A6265666F72657B626F726465722D636F6C6F723A7472';
wwv_flow_imp.g_varchar2_table(119) := '616E73706172656E747D2E7072657474792E702D726F746174653A6E6F74282E702D64656661756C742920696E7075743A636865636B65647E2E7374617465202E69636F6E2C2E7072657474792E702D726F746174653A6E6F74282E702D64656661756C';
wwv_flow_imp.g_varchar2_table(120) := '742920696E7075743A636865636B65647E2E7374617465202E7376672C2E7072657474792E702D726F746174653A6E6F74282E702D64656661756C742920696E7075743A636865636B65647E2E737461746520696D672C2E7072657474792E702D726F74';
wwv_flow_imp.g_varchar2_table(121) := '6174653A6E6F74282E702D64656661756C742920696E7075743A636865636B65647E2E7374617465206C6162656C3A61667465722C2E7072657474792E702D726F746174653A6E6F74282E702D64656661756C742920696E7075743A636865636B65647E';
wwv_flow_imp.g_varchar2_table(122) := '2E7374617465206C6162656C3A6265666F72657B2D7765626B69742D616E696D6174696F6E3A726F74617465202E37732063756269632D62657A696572282E32352C2E34362C2E34352C2E3934293B616E696D6174696F6E3A726F74617465202E377320';
wwv_flow_imp.g_varchar2_table(123) := '63756269632D62657A696572282E32352C2E34362C2E34352C2E3934293B6F7061636974793A317D2E7072657474792E702D726F746174653A6E6F74282E702D64656661756C742920696E7075743A636865636B65647E2E7374617465206C6162656C3A';
wwv_flow_imp.g_varchar2_table(124) := '6265666F72657B626F726465722D636F6C6F723A7472616E73706172656E747D2E7072657474792E702D70756C73653A6E6F74282E702D7377697463682920696E7075743A636865636B65647E2E7374617465206C6162656C3A6265666F72657B2D7765';
wwv_flow_imp.g_varchar2_table(125) := '626B69742D616E696D6174696F6E3A70756C73652031733B616E696D6174696F6E3A70756C73652031737D2E70726574747920696E7075745B64697361626C65645D7B637572736F723A6E6F742D616C6C6F7765643B646973706C61793A6E6F6E657D2E';
wwv_flow_imp.g_varchar2_table(126) := '70726574747920696E7075745B64697361626C65645D7E2A7B6F7061636974793A2E357D2E7072657474792E702D6C6F636B656420696E7075747B646973706C61793A6E6F6E653B637572736F723A6E6F742D616C6C6F7765647D2E7072657474792069';
wwv_flow_imp.g_varchar2_table(127) := '6E7075743A636865636B65647E2E73746174652E702D7072696D617279206C6162656C3A61667465722C2E7072657474792E702D746F67676C65202E73746174652E702D7072696D617279206C6162656C3A61667465727B6261636B67726F756E642D63';
wwv_flow_imp.g_varchar2_table(128) := '6F6C6F723A2334323862636121696D706F7274616E747D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D7072696D617279202E69636F6E2C2E70726574747920696E7075743A636865636B65647E2E73746174652E702D70';
wwv_flow_imp.g_varchar2_table(129) := '72696D617279202E7376672C2E7072657474792E702D746F67676C65202E73746174652E702D7072696D617279202E69636F6E2C2E7072657474792E702D746F67676C65202E73746174652E702D7072696D617279202E7376677B636F6C6F723A236666';
wwv_flow_imp.g_varchar2_table(130) := '663B7374726F6B653A236666667D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D7072696D6172792D6F206C6162656C3A6265666F72652C2E7072657474792E702D746F67676C65202E73746174652E702D7072696D6172';
wwv_flow_imp.g_varchar2_table(131) := '792D6F206C6162656C3A6265666F72657B626F726465722D636F6C6F723A233432386263617D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D7072696D6172792D6F206C6162656C3A61667465722C2E7072657474792E70';
wwv_flow_imp.g_varchar2_table(132) := '2D746F67676C65202E73746174652E702D7072696D6172792D6F206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A7472616E73706172656E747D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D70';
wwv_flow_imp.g_varchar2_table(133) := '72696D6172792D6F202E69636F6E2C2E70726574747920696E7075743A636865636B65647E2E73746174652E702D7072696D6172792D6F202E7376672C2E70726574747920696E7075743A636865636B65647E2E73746174652E702D7072696D6172792D';
wwv_flow_imp.g_varchar2_table(134) := '6F207376672C2E7072657474792E702D746F67676C65202E73746174652E702D7072696D6172792D6F202E69636F6E2C2E7072657474792E702D746F67676C65202E73746174652E702D7072696D6172792D6F202E7376672C2E7072657474792E702D74';
wwv_flow_imp.g_varchar2_table(135) := '6F67676C65202E73746174652E702D7072696D6172792D6F207376677B636F6C6F723A233432386263613B7374726F6B653A233432386263617D2E7072657474792E702D64656661756C743A6E6F74282E702D66696C6C2920696E7075743A636865636B';
wwv_flow_imp.g_varchar2_table(136) := '65647E2E73746174652E702D7072696D6172792D6F206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A2334323862636121696D706F7274616E747D2E7072657474792E702D73776974636820696E7075743A636865636B65647E';
wwv_flow_imp.g_varchar2_table(137) := '2E73746174652E702D7072696D6172793A6265666F72657B626F726465722D636F6C6F723A233432386263617D2E7072657474792E702D7377697463682E702D66696C6C20696E7075743A636865636B65647E2E73746174652E702D7072696D6172793A';
wwv_flow_imp.g_varchar2_table(138) := '6265666F72657B6261636B67726F756E642D636F6C6F723A2334323862636121696D706F7274616E747D2E7072657474792E702D7377697463682E702D736C696D20696E7075743A636865636B65647E2E73746174652E702D7072696D6172793A626566';
wwv_flow_imp.g_varchar2_table(139) := '6F72657B626F726465722D636F6C6F723A233234353638323B6261636B67726F756E642D636F6C6F723A2332343536383221696D706F7274616E747D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D696E666F206C616265';
wwv_flow_imp.g_varchar2_table(140) := '6C3A61667465722C2E7072657474792E702D746F67676C65202E73746174652E702D696E666F206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A2335626330646521696D706F7274616E747D2E70726574747920696E7075743A';
wwv_flow_imp.g_varchar2_table(141) := '636865636B65647E2E73746174652E702D696E666F202E69636F6E2C2E70726574747920696E7075743A636865636B65647E2E73746174652E702D696E666F202E7376672C2E7072657474792E702D746F67676C65202E73746174652E702D696E666F20';
wwv_flow_imp.g_varchar2_table(142) := '2E69636F6E2C2E7072657474792E702D746F67676C65202E73746174652E702D696E666F202E7376677B636F6C6F723A236666663B7374726F6B653A236666667D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D696E666F';
wwv_flow_imp.g_varchar2_table(143) := '2D6F206C6162656C3A6265666F72652C2E7072657474792E702D746F67676C65202E73746174652E702D696E666F2D6F206C6162656C3A6265666F72657B626F726465722D636F6C6F723A233562633064657D2E70726574747920696E7075743A636865';
wwv_flow_imp.g_varchar2_table(144) := '636B65647E2E73746174652E702D696E666F2D6F206C6162656C3A61667465722C2E7072657474792E702D746F67676C65202E73746174652E702D696E666F2D6F206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A7472616E73';
wwv_flow_imp.g_varchar2_table(145) := '706172656E747D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D696E666F2D6F202E69636F6E2C2E70726574747920696E7075743A636865636B65647E2E73746174652E702D696E666F2D6F202E7376672C2E7072657474';
wwv_flow_imp.g_varchar2_table(146) := '7920696E7075743A636865636B65647E2E73746174652E702D696E666F2D6F207376672C2E7072657474792E702D746F67676C65202E73746174652E702D696E666F2D6F202E69636F6E2C2E7072657474792E702D746F67676C65202E73746174652E70';
wwv_flow_imp.g_varchar2_table(147) := '2D696E666F2D6F202E7376672C2E7072657474792E702D746F67676C65202E73746174652E702D696E666F2D6F207376677B636F6C6F723A233562633064653B7374726F6B653A233562633064657D2E7072657474792E702D64656661756C743A6E6F74';
wwv_flow_imp.g_varchar2_table(148) := '282E702D66696C6C2920696E7075743A636865636B65647E2E73746174652E702D696E666F2D6F206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A2335626330646521696D706F7274616E747D2E7072657474792E702D737769';
wwv_flow_imp.g_varchar2_table(149) := '74636820696E7075743A636865636B65647E2E73746174652E702D696E666F3A6265666F72657B626F726465722D636F6C6F723A233562633064657D2E7072657474792E702D7377697463682E702D66696C6C20696E7075743A636865636B65647E2E73';
wwv_flow_imp.g_varchar2_table(150) := '746174652E702D696E666F3A6265666F72657B6261636B67726F756E642D636F6C6F723A2335626330646521696D706F7274616E747D2E7072657474792E702D7377697463682E702D736C696D20696E7075743A636865636B65647E2E73746174652E70';
wwv_flow_imp.g_varchar2_table(151) := '2D696E666F3A6265666F72657B626F726465722D636F6C6F723A233233393062303B6261636B67726F756E642D636F6C6F723A2332333930623021696D706F7274616E747D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D';
wwv_flow_imp.g_varchar2_table(152) := '73756363657373206C6162656C3A61667465722C2E7072657474792E702D746F67676C65202E73746174652E702D73756363657373206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A2335636238356321696D706F7274616E74';
wwv_flow_imp.g_varchar2_table(153) := '7D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D73756363657373202E69636F6E2C2E70726574747920696E7075743A636865636B65647E2E73746174652E702D73756363657373202E7376672C2E7072657474792E702D';
wwv_flow_imp.g_varchar2_table(154) := '746F67676C65202E73746174652E702D73756363657373202E69636F6E2C2E7072657474792E702D746F67676C65202E73746174652E702D73756363657373202E7376677B636F6C6F723A236666663B7374726F6B653A236666667D2E70726574747920';
wwv_flow_imp.g_varchar2_table(155) := '696E7075743A636865636B65647E2E73746174652E702D737563636573732D6F206C6162656C3A6265666F72652C2E7072657474792E702D746F67676C65202E73746174652E702D737563636573732D6F206C6162656C3A6265666F72657B626F726465';
wwv_flow_imp.g_varchar2_table(156) := '722D636F6C6F723A233563623835637D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D737563636573732D6F206C6162656C3A61667465722C2E7072657474792E702D746F67676C65202E73746174652E702D7375636365';
wwv_flow_imp.g_varchar2_table(157) := '73732D6F206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A7472616E73706172656E747D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D737563636573732D6F202E69636F6E2C2E707265747479';
wwv_flow_imp.g_varchar2_table(158) := '20696E7075743A636865636B65647E2E73746174652E702D737563636573732D6F202E7376672C2E70726574747920696E7075743A636865636B65647E2E73746174652E702D737563636573732D6F207376672C2E7072657474792E702D746F67676C65';
wwv_flow_imp.g_varchar2_table(159) := '202E73746174652E702D737563636573732D6F202E69636F6E2C2E7072657474792E702D746F67676C65202E73746174652E702D737563636573732D6F202E7376672C2E7072657474792E702D746F67676C65202E73746174652E702D73756363657373';
wwv_flow_imp.g_varchar2_table(160) := '2D6F207376677B636F6C6F723A233563623835633B7374726F6B653A233563623835637D2E7072657474792E702D64656661756C743A6E6F74282E702D66696C6C2920696E7075743A636865636B65647E2E73746174652E702D737563636573732D6F20';
wwv_flow_imp.g_varchar2_table(161) := '6C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A2335636238356321696D706F7274616E747D2E7072657474792E702D73776974636820696E7075743A636865636B65647E2E73746174652E702D737563636573733A6265666F72';
wwv_flow_imp.g_varchar2_table(162) := '657B626F726465722D636F6C6F723A233563623835637D2E7072657474792E702D7377697463682E702D66696C6C20696E7075743A636865636B65647E2E73746174652E702D737563636573733A6265666F72657B6261636B67726F756E642D636F6C6F';
wwv_flow_imp.g_varchar2_table(163) := '723A2335636238356321696D706F7274616E747D2E7072657474792E702D7377697463682E702D736C696D20696E7075743A636865636B65647E2E73746174652E702D737563636573733A6265666F72657B626F726465722D636F6C6F723A2333353739';
wwv_flow_imp.g_varchar2_table(164) := '33353B6261636B67726F756E642D636F6C6F723A2333353739333521696D706F7274616E747D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D7761726E696E67206C6162656C3A61667465722C2E7072657474792E702D74';
wwv_flow_imp.g_varchar2_table(165) := '6F67676C65202E73746174652E702D7761726E696E67206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A2366306164346521696D706F7274616E747D2E70726574747920696E7075743A636865636B65647E2E73746174652E70';
wwv_flow_imp.g_varchar2_table(166) := '2D7761726E696E67202E69636F6E2C2E70726574747920696E7075743A636865636B65647E2E73746174652E702D7761726E696E67202E7376672C2E7072657474792E702D746F67676C65202E73746174652E702D7761726E696E67202E69636F6E2C2E';
wwv_flow_imp.g_varchar2_table(167) := '7072657474792E702D746F67676C65202E73746174652E702D7761726E696E67202E7376677B636F6C6F723A236666663B7374726F6B653A236666667D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D7761726E696E672D';
wwv_flow_imp.g_varchar2_table(168) := '6F206C6162656C3A6265666F72652C2E7072657474792E702D746F67676C65202E73746174652E702D7761726E696E672D6F206C6162656C3A6265666F72657B626F726465722D636F6C6F723A236630616434657D2E70726574747920696E7075743A63';
wwv_flow_imp.g_varchar2_table(169) := '6865636B65647E2E73746174652E702D7761726E696E672D6F206C6162656C3A61667465722C2E7072657474792E702D746F67676C65202E73746174652E702D7761726E696E672D6F206C6162656C3A61667465727B6261636B67726F756E642D636F6C';
wwv_flow_imp.g_varchar2_table(170) := '6F723A7472616E73706172656E747D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D7761726E696E672D6F202E69636F6E2C2E70726574747920696E7075743A636865636B65647E2E73746174652E702D7761726E696E67';
wwv_flow_imp.g_varchar2_table(171) := '2D6F202E7376672C2E70726574747920696E7075743A636865636B65647E2E73746174652E702D7761726E696E672D6F207376672C2E7072657474792E702D746F67676C65202E73746174652E702D7761726E696E672D6F202E69636F6E2C2E70726574';
wwv_flow_imp.g_varchar2_table(172) := '74792E702D746F67676C65202E73746174652E702D7761726E696E672D6F202E7376672C2E7072657474792E702D746F67676C65202E73746174652E702D7761726E696E672D6F207376677B636F6C6F723A236630616434653B7374726F6B653A236630';
wwv_flow_imp.g_varchar2_table(173) := '616434657D2E7072657474792E702D64656661756C743A6E6F74282E702D66696C6C2920696E7075743A636865636B65647E2E73746174652E702D7761726E696E672D6F206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A2366';
wwv_flow_imp.g_varchar2_table(174) := '306164346521696D706F7274616E747D2E7072657474792E702D73776974636820696E7075743A636865636B65647E2E73746174652E702D7761726E696E673A6265666F72657B626F726465722D636F6C6F723A236630616434657D2E7072657474792E';
wwv_flow_imp.g_varchar2_table(175) := '702D7377697463682E702D66696C6C20696E7075743A636865636B65647E2E73746174652E702D7761726E696E673A6265666F72657B6261636B67726F756E642D636F6C6F723A2366306164346521696D706F7274616E747D2E7072657474792E702D73';
wwv_flow_imp.g_varchar2_table(176) := '77697463682E702D736C696D20696E7075743A636865636B65647E2E73746174652E702D7761726E696E673A6265666F72657B626F726465722D636F6C6F723A236337376331313B6261636B67726F756E642D636F6C6F723A2363373763313121696D70';
wwv_flow_imp.g_varchar2_table(177) := '6F7274616E747D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D64616E676572206C6162656C3A61667465722C2E7072657474792E702D746F67676C65202E73746174652E702D64616E676572206C6162656C3A61667465';
wwv_flow_imp.g_varchar2_table(178) := '727B6261636B67726F756E642D636F6C6F723A2364393533346621696D706F7274616E747D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D64616E676572202E69636F6E2C2E70726574747920696E7075743A636865636B';
wwv_flow_imp.g_varchar2_table(179) := '65647E2E73746174652E702D64616E676572202E7376672C2E7072657474792E702D746F67676C65202E73746174652E702D64616E676572202E69636F6E2C2E7072657474792E702D746F67676C65202E73746174652E702D64616E676572202E737667';
wwv_flow_imp.g_varchar2_table(180) := '7B636F6C6F723A236666663B7374726F6B653A236666667D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D64616E6765722D6F206C6162656C3A6265666F72652C2E7072657474792E702D746F67676C65202E7374617465';
wwv_flow_imp.g_varchar2_table(181) := '2E702D64616E6765722D6F206C6162656C3A6265666F72657B626F726465722D636F6C6F723A236439353334667D2E70726574747920696E7075743A636865636B65647E2E73746174652E702D64616E6765722D6F206C6162656C3A61667465722C2E70';
wwv_flow_imp.g_varchar2_table(182) := '72657474792E702D746F67676C65202E73746174652E702D64616E6765722D6F206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A7472616E73706172656E747D2E70726574747920696E7075743A636865636B65647E2E737461';
wwv_flow_imp.g_varchar2_table(183) := '74652E702D64616E6765722D6F202E69636F6E2C2E70726574747920696E7075743A636865636B65647E2E73746174652E702D64616E6765722D6F202E7376672C2E70726574747920696E7075743A636865636B65647E2E73746174652E702D64616E67';
wwv_flow_imp.g_varchar2_table(184) := '65722D6F207376672C2E7072657474792E702D746F67676C65202E73746174652E702D64616E6765722D6F202E69636F6E2C2E7072657474792E702D746F67676C65202E73746174652E702D64616E6765722D6F202E7376672C2E7072657474792E702D';
wwv_flow_imp.g_varchar2_table(185) := '746F67676C65202E73746174652E702D64616E6765722D6F207376677B636F6C6F723A236439353334663B7374726F6B653A236439353334667D2E7072657474792E702D64656661756C743A6E6F74282E702D66696C6C2920696E7075743A636865636B';
wwv_flow_imp.g_varchar2_table(186) := '65647E2E73746174652E702D64616E6765722D6F206C6162656C3A61667465727B6261636B67726F756E642D636F6C6F723A2364393533346621696D706F7274616E747D2E7072657474792E702D73776974636820696E7075743A636865636B65647E2E';
wwv_flow_imp.g_varchar2_table(187) := '73746174652E702D64616E6765723A6265666F72657B626F726465722D636F6C6F723A236439353334667D2E7072657474792E702D7377697463682E702D66696C6C20696E7075743A636865636B65647E2E73746174652E702D64616E6765723A626566';
wwv_flow_imp.g_varchar2_table(188) := '6F72657B6261636B67726F756E642D636F6C6F723A2364393533346621696D706F7274616E747D2E7072657474792E702D7377697463682E702D736C696D20696E7075743A636865636B65647E2E73746174652E702D64616E6765723A6265666F72657B';
wwv_flow_imp.g_varchar2_table(189) := '626F726465722D636F6C6F723A236130323632323B6261636B67726F756E642D636F6C6F723A2361303236323221696D706F7274616E747D2E7072657474792E702D626967676572202E69636F6E2C2E7072657474792E702D626967676572202E696D67';
wwv_flow_imp.g_varchar2_table(190) := '2C2E7072657474792E702D626967676572202E7376672C2E7072657474792E702D626967676572206C6162656C3A61667465722C2E7072657474792E702D626967676572206C6162656C3A6265666F72657B666F6E742D73697A653A312E32656D21696D';
wwv_flow_imp.g_varchar2_table(191) := '706F7274616E743B746F703A63616C6328283025202D202831303025202D2031656D2929202D203335252921696D706F7274616E747D2E7072657474792E702D626967676572206C6162656C7B746578742D696E64656E743A312E37656D7D406D656469';
wwv_flow_imp.g_varchar2_table(192) := '61207072696E747B2E707265747479202E7374617465202E69636F6E2C2E707265747479202E7374617465206C6162656C3A61667465722C2E707265747479202E7374617465206C6162656C3A6265666F72652C2E707265747479202E73746174653A62';
wwv_flow_imp.g_varchar2_table(193) := '65666F72657B636F6C6F722D61646A7573743A65786163743B2D7765626B69742D7072696E742D636F6C6F722D61646A7573743A65786163743B7072696E742D636F6C6F722D61646A7573743A65786163747D7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(26712744639197091)
,p_plugin_id=>wwv_flow_imp.id(24181232782723321)
,p_file_name=>'pretty-checkbox.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
