<div class="modal fade" id="employeeResultDialog" role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Employee Information</h4>
            </div>

            <div class="modal-body">
                <div>
                    <g:if test="${empList}">
                        <table class="table table-bordered table-striped">
                            <thead>
                            <td>Select</td>
                            <td>User ID</td>
                            <td>First Name</td>
                            <td>Last Name</td>
                            <td>Email ID</td>
                            </thead>
                            <g:each in="${empList}" var="emp">
                                <tr>
                                    <td><input type="radio" name="selectedEmployee" id="selectedEmployee" data-empid="${emp.userId}" data-empname="${emp.lastName}, ${emp.firstName}"
                                               data-empemail="${emp?.email}"> </td>
                                    <td>
                                        ${emp?.userId}
                                    </td>
                                    <td>
                                        ${emp?.firstName}
                                    </td>
                                    <td>
                                        ${emp?.lastName}
                                    </td>
                                    <td>
                                        ${emp?.email}
                                    </td>
                                </tr>
                            </g:each>
                        </table>
                    </g:if>
                    <g:else>
                        No Data To Show
                    </g:else>
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-sm btn-primary" data-dismiss="modal" onclick="setEmpInfo()">Select</button>
            </div>
        </div>

    </div>

</div>