import React from 'react';

interface ApplicationGridProps {
  children: React.ReactNode;
}

const ApplicationGrid: React.FC<ApplicationGridProps> = ({ children }) => {
  return (
    <div className="portal-module-grid">
      {children}
    </div>
  );
};

export default ApplicationGrid;