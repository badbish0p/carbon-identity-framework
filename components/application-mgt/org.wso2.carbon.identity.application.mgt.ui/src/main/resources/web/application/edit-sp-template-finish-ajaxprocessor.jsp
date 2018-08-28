<%--
  ~ Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~ WSO2 Inc. licenses this file to you under the Apache License,
  ~ Version 2.0 (the "License"); you may not use this file except
  ~ in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>

<%@ page import="org.apache.axis2.context.ConfigurationContext"%>
<%@ page import="org.wso2.carbon.CarbonConstants"%>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil"%>
<%@ page import="org.wso2.carbon.utils.ServerConstants"%>
<%@ page import="org.wso2.carbon.ui.CarbonUIMessage" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.wso2.carbon.identity.application.mgt.ui.client.ApplicationManagementServiceClient" %>
<%@ page import="org.wso2.carbon.identity.application.common.model.xsd.SpTemplate" %>

<%
    String httpMethod = request.getMethod();
    if (!"post".equalsIgnoreCase(httpMethod)) {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        return;
    }
    String content = request.getParameter("templateContent");
    String templateName = request.getParameter("sp-template-name");
    String modifiedTemplateName = request.getParameter("template-name");
    String modifiedTemplateDesc = request.getParameter("template-description");
    if (StringUtils.isNotEmpty(content)) {
        try {
            String cookie = (String) session.getAttribute(ServerConstants.ADMIN_SERVICE_COOKIE);
            String backendServerURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
            ConfigurationContext configContext = (ConfigurationContext) config.getServletContext()
                    .getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);
            ApplicationManagementServiceClient serviceClient = new ApplicationManagementServiceClient(
                    cookie, backendServerURL, configContext);
            SpTemplate spTemplate = new SpTemplate();
            spTemplate.setName(modifiedTemplateName);
            spTemplate.setDescription(modifiedTemplateDesc);
            spTemplate.setContent(content);
            serviceClient.updateApplicationTemplate(templateName, spTemplate);
%>
<script>
    location.href = 'list-sp-templates.jsp';
</script>
<%
} catch (Exception e) {
    CarbonUIMessage.sendCarbonUIMessage(e.getMessage(), CarbonUIMessage.ERROR, request, e);
%>
<script>
    location.href = 'list-sp-templates.jsp';
</script>
<%
    }
} else {
    CarbonUIMessage.sendCarbonUIMessage("Template content should be available.", CarbonUIMessage.ERROR, request);
%>
<script>
    location.href = 'list-sp-templates.jsp';
</script>
<%
    }
%>
