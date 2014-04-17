--
-- Author: yangkai
-- E-mail: yk81708090@163.com
-- Date: 2014-04-04 11:06:28
--

local TableViewLayer = class("TableViewLayer")
TableViewLayer.__index = TableViewLayer

local count = 0  -- 获取箱子数量

function TableViewLayer.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, TableViewLayer)
    return target
end

function TableViewLayer.scrollViewDidScroll(view)
    print("scrollViewDidScroll")
end

function TableViewLayer.scrollViewDidZoom(view)
    print("scrollViewDidZoom")
end

function TableViewLayer.tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
    --[[
		此处可以通过再定义一个变量用来保存当前的使用几个箱子， 在根据cell:getIdx()的数值做比较
		即可判断当前是否点击到
    ]]
end

function TableViewLayer.cellSizeForTable(table,idx)
    return 96,94
end

function TableViewLayer.tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local label = nil
    if nil == cell then
        cell = CCTableViewCell:new()
        local sprite = CCSprite:create("sc_wp_box_tianjia_n.png")
        sprite:setAnchorPoint(CCPointMake(0,0))
        sprite:setPosition(CCPointMake(0, 0))
        cell:addChild(sprite)

        label = CCLabelTTF:create(strValue, "Helvetica", 20.0)
        label:setPosition(CCPointMake(0,0))
        label:setAnchorPoint(CCPointMake(0,0))
        label:setTag(123)
        cell:addChild(label)
    else
        label = tolua.cast(cell:getChildByTag(123),"CCLabelTTF")
        if nil ~= label then
            label:setString(strValue)
        end
    end

    return cell
end

function TableViewLayer.numberOfCellsInTableView(table)
   -- 获取数据
   return count
end

-- 初始化tabelview
function TableViewLayer:init()

    local winSize = CCDirector:sharedDirector():getWinSize()

    local tableView = CCTableView:create(CCSizeMake(565, 127)) 	-- 设置大小
    tableView:setDirection(kCCScrollViewDirectionHorizontal)	-- 设置横向
    tableView:setAnchorPoint(ccp(0.5, 0.5))
    tableView:setPosition(ccp(display.cx - 282.5, display.cy-325))	-- 设置位置
    tableView:setVerticalFillOrder(kCCTableViewFillTopDown)		-- 设置滑动方向
    self:addChild(tableView)
    -- 添加注册事件
    tableView:registerScriptHandler(TableViewLayer.scrollViewDidScroll,CCTableView.kTableViewScroll)
    tableView:registerScriptHandler(TableViewLayer.scrollViewDidZoom,CCTableView.kTableViewZoom)
    tableView:registerScriptHandler(TableViewLayer.tableCellTouched,CCTableView.kTableCellTouched)
    tableView:registerScriptHandler(TableViewLayer.cellSizeForTable,CCTableView.kTableCellSizeForIndex)
    tableView:registerScriptHandler(TableViewLayer.tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
    tableView:registerScriptHandler(TableViewLayer.numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
    tableView:reloadData() -- 刷新数据
    
    return true
end

function setCellCount(icount)
	count = icount
end

function create()
    local layer = TableViewLayer.extend(CCLayer:create())
    if nil ~= layer then
        layer:init()
    end

    return layer
end

