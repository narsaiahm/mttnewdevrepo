<%@ page import="org.mountsinai.mortalitytriggersystem.AdminConstants" %>
<form id="=assignUserFormId">

    <div class="col-md-12">
        <div class="col-md-6">
            <div class="col-sm-12">
                <div class="row form-group">
                    <div class="col-sm-10">
                        <label class="control-label">Search for an Employee:</label>
                        <input class="form-control " name="username"  id="username"
                              onfocus="removeErrorClass()">
                    </div>

                    <div class="col-sm-2" style="margin-top: 17px;margin-left: -20px;">
                        <button id="searchEmployee" onclick="searchEmplList()" type="button"
                                class="btn btn-primary "><span class="glyphicon glyphicon-search"></span></button>
                     </div>
                </div>

                <div class="row">
                    <div class="form-group col-md-10">
                        <label class="control-label">Employee Name:</label>
                        <input class="form-control " type="text" value="" readonly="true" id="empName">
                    </div>
                </div>
                <div class="row">
                    <div class="form-group col-md-10">
                        <label class="control-label">Employee Email:</label>
                        <input class="form-control " type="text" value="" readonly="true" id="assignEmailId">
                    </div>
                </div>

                <div class="row">
                    <div class="form-group col-md-10">
                        <p id="empError" style="color: red;"></p>
                    </div>
                </div>

            </div>

        </div>

        <div class="col-md-6">
            <div class="row">
                <div class="form-group col-md-6">
                    <label class="control-label">MSHS Hospital</label>
                    <g:select from="${facilityMap}" class="form-control"
                              id="facility" name="facility" optionKey="key" optionValue="value"
                              onchange="getDepartmentList(this)" noSelection="['': '-Select-']"/>
                </div>
            </div>

            <div class="row">
                <div class="form-group col-md-6">
                    <label class="control-label">MSHS Department</label>
                    <g:select from="${departmentMap}" class="form-control"
                              id="department" name="department" optionKey="key" optionValue="value"
                              onchange="getSepcialityList(this)" noSelection="['': '-Select-']"/>

                </div>
            </div>

            <div class="row">
                <div class="form-group col-md-6">
                    <label class="control-label">Specialty</label>

                    <g:select from="${specialitiesMap}" class="form-control"
                              id="speciality" name="speciality" optionKey="key" optionValue="value"
                              noSelection="['': '-Select-']"/>

                </div>
            </div>

            <div class="row">
                <div class="form-group col-md-12">
                    <p id="error" style="color: red"></p>
                </div>
            </div>
        </div>

    </div>

    <div class="center buttonSection">
        <g:if test="${params?.isReassignForm == "false"}">
            <g:if test="${session?.user?.role?.roleName.equals(AdminConstants.ADMIN)}">
                <g:link value="Cancel" action="adminDashboard" class="btn btn-primary ">Cancel</g:link>
            </g:if>
            <g:elseif
                    test="${(session?.user?.role?.roleName.equals(AdminConstants.QUALITY_LEAD) || session?.user?.role?.roleName.equals(AdminConstants.ADHOC))}">
                <g:link value="Cancel" action="qlDashboard" class="btn btn-primary ">Cancel</g:link>
            </g:elseif>
        </g:if>
        <g:if test="${params?.isReassignForm == "true" || params?.isReassignForm == null}">
            <button type="button" class="btn btn-primary cancelButton"
                    onclick="window.history.back();">Cancel</button>
        </g:if>
            <button value="Save" id="saveButtonId" onclick="assignQl()" type="button"
                    class="btn btn-primary ">Add</button>

    </div>

</form>

