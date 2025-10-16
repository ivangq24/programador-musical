import React from 'react';
import { PieChart } from 'lucide-react';

// Sección Reportes
export const ReportesSection = () => {
  const items = [
    { name: 'Reportes disponibles', icon: PieChart }
  ];

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
      <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-blue-500 to-blue-600">
        <h3 className="text-white font-semibold text-sm">Reportes</h3>
      </div>
      <div className="flex-1 p-3 overflow-hidden">
        <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button key={itemIndex} className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left">
                <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-blue-100 group-hover:bg-blue-200">
                  <ItemIcon className="w-3 h-3 text-blue-600" />
                </div>
                <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900 leading-tight truncate">{item.name}</span>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
};
