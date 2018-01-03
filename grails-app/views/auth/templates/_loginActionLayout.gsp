
<div class="container">

%{--<div class="top-buffer textAlign-center"><label>Action Items</label></div>--}%
<div class="col-sm-10 center-table">
    <table class="table table-bordered table-striped">
        <thead>
        <tr>
            <th class="text-center col-sm-4"><label class="control-label">Facility</label></th>
            <th class="text-center col-sm-4"><label class="control-label">Department/Speciality</label></th>
            <th class="col-sm-2">Role</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${users}" var="user">
        <tr>
            <td class="">${user?.facility?.facilityName}</td>
            <td class="">
                <g:if test="${user?.speciality}">
                    ${user?.speciality}
                </g:if>
                <g:elseif test="${user?.dept}">
                    ${user?.dept?.departmentName}
                </g:elseif>
            </td>
            <td class="">
                <g:link role="button" action="loginAction" class="btn btn-info btn-sm bnt-responsive" params="[userId:user.id]">
                    ${user?.role}
                </g:link>
            </td>
        </tr>
        </g:each>
        </tbody>
    </table>
</div></div>