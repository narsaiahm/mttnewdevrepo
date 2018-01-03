<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
</head>

<body>
<div class="container">
    <div class="center">
        <p><label class="labelArea center" style="width:29%">Assign MSHS Employees to Clinical Quality Lead</label></p>


        <div class="form-group margin">

            <label class="radio-inline">
                <input type="radio" id="assign" name="assign" value="assign" checked="checked"
                       onclick="showAssignChange(this)"/>Assign
            </label>
            <label class="radio-inline">
                <input type="radio" id="unassign" name="assign" value="unassign"
                       onclick="showUnassignChange(this)"/>Unassign
            </label>
        </div>
    </div>

    <div id="assignQl" style="display: none">
        <g:render template="/mortality/templates/assignUser"></g:render>
    </div>

    <div id="unassignQl" style="display: none">
        <g:render template="/mortality/templates/unassignUser"></g:render>
    </div>

    <div id="employeeResult"></div>
</div>
</body>
</html>