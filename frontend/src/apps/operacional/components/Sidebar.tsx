import React, { createContext, useContext, useState, useEffect } from 'react';

const SidebarContext = createContext(null);

export const SidebarProvider = ({ children }) => {
  const [isOpen, setIsOpen] = useState(true);
  const [activeItem, setActiveItem] = useState('home');

  const toggle = () => setIsOpen(prev => !prev);
  const setActive = (item) => setActiveItem(item);

  return (
    <SidebarContext.Provider value={{ isOpen, toggle, activeItem, setActive }}>
      {children}
    </SidebarContext.Provider>
  );
};

export const useSidebar = () => useContext(SidebarContext);
