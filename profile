package com.adobe.aem.aemtraining.core.servlets;

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingSafeMethodsServlet;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ResourceResolverFactory;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.apache.sling.api.servlets.ServletResolverConstants;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import java.io.IOException;
import java.util.Map;

@Component(
    service = {Servlet.class},
    property = {
        ServletResolverConstants.SLING_SERVLET_PATHS + "=/bin/readprofileproperty",
        ServletResolverConstants.SLING_SERVLET_METHODS + "=GET"
    }
)
public class ReadProfilePropertyServlet extends SlingSafeMethodsServlet {

    @Reference
    private ResourceResolverFactory resourceResolverFactory;

    @Override
    protected void doGet(final SlingHttpServletRequest request,
                         final SlingHttpServletResponse response) throws ServletException, IOException {
        ResourceResolver resourceResolver = null;
        try {
            // Obtain a resource resolver with read permissions
            Map<String, Object> authInfo = Map.of(ResourceResolverFactory.SUBSERVICE, "readService");
            resourceResolver = resourceResolverFactory.createWriter(authInfo);

            // Path to the profile node
            String path = "/content/crxlite/abcd/profile";
            Resource resource = resourceResolver.getResource(path);

            if (resource != null) {
                // Read the properties
                String email = resource.getValueMap().get("email", String.class);
                String familyName = resource.getValueMap().get("familyname", String.class);
                String givenName = resource.getValueMap().get("givenname", String.class);
                String groups = resource.getValueMap().get("groups", String.class);

                // Output the properties
                response.getWriter().write("Email: " + (email != null ? email : "Not found") + "<br>");
                response.getWriter().write("Family Name: " + (familyName != null ? familyName : "Not found") + "<br>");
                response.getWriter().write("Given Name: " + (givenName != null ? givenName : "Not found") + "<br>");
                response.getWriter().write("Groups: " + (groups != null ? groups : "Not found") + "<br>");
            } else {
                response.getWriter().write("Resource not found at path: " + path);
            }
        } catch (Exception e) {
            response.getWriter().write("Error: " + e.getMessage());
        } finally {
            if (resourceResolver != null) {
                resourceResolver.close();
            }
        }
    }
}
