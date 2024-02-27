import { Component, OnInit } from '@angular/core';
import { ProdutoModel } from 'src/app/models/ProdutoModel';
import { ProdutoService } from '../../services/produto.service';
import { ActivatedRoute, Router } from '@angular/router';
import { FornecedorModel } from 'src/app/models/FornecedorModel';
import { FornecedorService } from '../../services/fornecedor.service';
import { SelectItem } from 'primeng/api';
import { Message, MessageService } from 'primeng/api';
import { AbstractControl, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { PecaModel } from 'src/app/models/PecaModel';
import { PecaEstoqueModel } from 'src/app/models/PecaEstoqueModel';
import { PecaService } from 'src/app/services/peca.service';
import { PecaEstoqueService } from 'src/app/services/pecaestoque.service';

function lettersOnly(control: AbstractControl): { [key: string]: any } | null {
  const lettersPattern = /^[A-Za-z]+$/;
  let value = control.value;

  if (value == null || value === '') {
    return null; // Skip validation if the value is null or empty
  }

  if (typeof value !== 'string') {
    value = value.toString(); // Convert to string if value is not already a string
  }

  if (!lettersPattern.test(value.replace(/\s/g, '')) || value.length < 4) {
    return { lettersOnly: true };
  }

  return null;
}

@Component({
  selector: 'app-pecaestoque-form',
  templateUrl: './pecaestoque-form.component.html',
  styleUrls: ['./pecaestoque-form.component.css']
})
export class PecaEstoqueFormComponent implements OnInit {
  displayDialog: boolean = true;
  pecas: PecaModel[] = [];
  filteredPecas: PecaModel[] = [];
  msgs: Message[] = [];
  pageTitle: string = 'Estoque';
  pecaEstoqueForm: FormGroup;
  //filteredPecasM: PecaModel[] = [];
  selectedPeca: PecaModel | null = null;
  pecaEstoque: PecaEstoqueModel | undefined;

  ngOnInit(): void {
    this.buildForm();

    this.pecaService.list().subscribe(pecas => {
      this.pecas = pecas;
    });
  }

  constructor(
    private pecaEstoqueService: PecaEstoqueService,
    private router: Router,
    private route: ActivatedRoute,
    private pecaService: PecaService,
    private messageService: MessageService,
    private formBuilder: FormBuilder
  ) {

    this.pecaEstoqueForm = this.formBuilder.group({});

  }

  pecaestoque: PecaEstoqueModel = {
    quantidadeMaxima: 0,
    quantidadeMinima: 0,
    saldoDisponivel: 0,
    quantidadeIdeal: 0,
    peca: new PecaModel(),
    saldoReservado: 0,
  };

  searchPecas(event: any) {
    this.filteredPecas = this.pecas.filter(peca =>
      peca?.descricao?.toLowerCase().includes(event.query.toLowerCase())
    );

    this.selectedPeca = null;
  }

  public salvar() {
    if (this.pecaEstoqueForm.invalid) {
      return;
    }

    this.pecaestoque = { ...this.pecaestoque, ...this.pecaEstoqueForm.value };

    console.log(this.pecaEstoque);

    this.pecaEstoqueService.add(this.pecaestoque).subscribe(() => {
      this.router.navigateByUrl('/pecaestoqueList');
    });
  }

  cancelar(): void {
    this.router.navigateByUrl('/pecaestoqueList');
  }

  onDialogHide(): void {
    this.cancelar();
  }

  private buildForm(): void {
    this.pecaEstoqueForm = this.formBuilder.group({
      quantidadeMaxima: ['', Validators.required],
      quantidadeMinima: [null, Validators.required],
      saldoDisponivel: [null, Validators.required],
      quantidadeIdeal: [null, Validators.required],
      peca: [null, Validators.required]// Use 'fornecedor' as the form control name
    });
  }
}
