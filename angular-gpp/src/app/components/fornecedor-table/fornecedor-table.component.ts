import { ChangeDetectorRef, Component, OnInit, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { LocalDataSource } from 'ng2-smart-table';
import { FornecedorService } from 'src/app/services/fornecedor.service';
import { Table } from 'primeng/table';
import { FornecedorModel } from 'src/app/models/FornecedorModel';

@Component({
  selector: 'app-fornecedor-table',
  templateUrl: './fornecedor-table.component.html',
  styleUrls: ['./fornecedor-table.component.css']
})
export class FornecedorTableComponent implements OnInit {
  @ViewChild('dt2') dt2!: Table;

  fornecedores: FornecedorModel[] = [];
  source: LocalDataSource = new LocalDataSource(this.fornecedores);
  pageTitle = 'Fornecedor';

  constructor(
    private fornecedorService: FornecedorService,
    private router: Router,
    private cdr: ChangeDetectorRef
  ) {}

  ngAfterViewInit() {
    // console.log('dt2:', this.dt2);
  }

  ngOnInit(): void {
    this.list();
  }

  list(): void {
    this.fornecedorService.list().subscribe(resp => {
      this.fornecedores = resp;
    });
  }

  novo(): void {
    this.router.navigateByUrl('/fornecedor/novo');
  }

  onCustomAction(event: any): void {
    const fornecedor: FornecedorModel = event.data;
    console.log(event);
    this.router.navigate([`fornecedor/${fornecedor.idFornecedor}`]);
  }

  editeFornecedor(fornecedor: FornecedorModel): void {
    this.router.navigateByUrl(`/fornecedor/editar/${fornecedor.idFornecedor}`);
  }

  editFornecedor(id: number): void {
    this.router.navigate(['/fornecedor/editar', id]);
  }

  deleteFornecedor(id: number): void {
    // console.log('deletar fornecedor');
    this.fornecedorService.delete(id).subscribe(() => {
      this.list();
      // console.log(`Fornecedor ${id} foi deletada`);
    });
  }

  onSearch(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    // console.log('Search value:', value);
    this.dt2?.filterGlobal(value, 'contains');
    // console.log('Filtered data:', this.dt2?.value);
    this.cdr.detectChanges(); // trigger change detection
    // console.log('test data:', this.dt2?.value);
  }

    adicionarFornecedor(): void {
    this.router.navigateByUrl(`fornecedor/:id`);
  }

  
}
