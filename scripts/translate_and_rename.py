#!/usr/bin/env python3
"""
Renombra assets descargados de Figma desde vietnamita a español y actualiza lib/screens.dart.
"""
import os
from pathlib import Path

MAPPING = {
    'Bản đồ giao hàng': 'mapa_envio',
    'Chi tiết công việc': 'detalle_tarea',
    'Chi tiết sản phẩm': 'detalle_producto',
    'Chi tiết đề nghị thanh toán': 'detalle_solicitud_pago',
    'Chi tiết đề nghị tạm ứng': 'detalle_solicitud_ant',
    'Chi tiết đơn hàng chưa nhận': 'detalle_pedido_no_recibido',
    'Chi tiết đơn hàng delay': 'detalle_pedido_delay',
    'Chi tiết đơn hàng vận chuyển': 'detalle_pedido_transporte',
    'Chi tiết đơn hàng đang giao': 'detalle_pedido_en_entrega',
    'Chi tiết đơn hàng đang đóng': 'detalle_pedido_cerrado',
    'Chi tiết đơn đăng ký phòng họp': 'detalle_solicitud_sala',
    'Chi tiết đăng ký nghỉ phép': 'detalle_solicitud_vacaciones',
    'Chi tiết đăng ký sử dụng xe': 'detalle_solicitud_vehiculo',
    'Chưa có đơn giao': 'sin_pedidos_entrega',
    'Chưa có đơn hàng': 'sin_pedidos',
    'Công việc bàn làm việc': 'tareas_escritorio',
    'Công việc': 'tareas',
    'Danh sách đề nghị thanh toán': 'lista_solicitudes_pago',
    'Danh sách đề nghị tạm ứng': 'lista_solicitudes_ant',
    'Duyệt đơn đăng ký': 'revisar_solicitudes',
    'Duyệt đăng ký phòng họp': 'aprobar_sala',
    'Duyệt đăng ký sử dụng xe': 'aprobar_vehiculo',
    'Form đăng ký nghỉ phép': 'formulario_vacaciones',
    'Lịch sử chấm công': 'historial_asistencia',
    'Lịch': 'calendario',
    'Thêm mới công việc': 'nueva_tarea',
    'Thông báo': 'notificaciones',
    'Trang chủ 1': 'inicio_1',
    'Trang chủ 2': 'inicio_2',
    'Trang chủ thông báo': 'inicio_notificaciones',
    'Tệp đính kèm': 'adjuntos',
    'Đơn của tôi': 'mis_pedidos',
    'Đơn hàng chưa đóng': 'pedidos_pendientes',
    'Đơn hàng delay': 'pedidos_retrasados',
    'Đơn hàng đã lấy': 'pedidos_entregados',
    'Đăng ký nghỉ phép': 'registro_vacaciones',
    'Đăng ký phòng họp': 'registro_sala',
    'Đăng ký sử dụng xe': 'registro_vehiculo',
    'Đăng nhập - 1': 'login',
    'google logo': 'logo_google',
    'Misc': 'varios',
    'Status Icons': 'iconos_estado',
    '9_41': 'like_notch',
    'iPhone 13 _ 13 Pro - 1': 'iphone_13_1',
    'iPhone 13 _ 13 Pro - 2': 'iphone_13_2',
}

ASSETS_DIR = Path('assets/figma')

def safe_rename(old_name: str):
    for orig, esp in MAPPING.items():
        if old_name.startswith(orig):
            suffix = old_name[len(orig):]
            # preserve the suffix (id etc)
            new_name = esp + suffix
            return new_name
    # fallback: replace spaces with underscores and remove accents
    candidate = old_name.replace(' ', '_')
    return candidate


def main():
    files = list(ASSETS_DIR.iterdir())
    renamed = []
    for f in files:
        name = f.name
        new_name = safe_rename(name)
        if new_name != name:
            new_path = ASSETS_DIR / new_name
            print(f'Renaming: {name} -> {new_name}')
            f.rename(new_path)
            renamed.append((name, new_name))

    # Update lib/screens.dart if exists
    screens_path = Path('lib/screens.dart')
    if screens_path.exists():
        txt = screens_path.read_text(encoding='utf-8')
        for old, new in renamed:
            # Replace occurrences of old display name (without extension) with new esp name (approx)
            old_display = old.rsplit('-', 1)[0]
            new_display = new.rsplit('-', 1)[0]
            txt = txt.replace(old_display, new_display)
        screens_path.write_text(txt, encoding='utf-8')
        print('Updated lib/screens.dart')

    print('Done')

if __name__ == '__main__':
    main()
